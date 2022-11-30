#!/usr/bin/env ruby
name = gets

puts "My name is #{name}!"
class MagicBus < Array

  attr_writer :seating

  def add_passengers_from_role(list_of_passengers = '')
    reject_strs = [/[";&,.]/, "and", "\\n", "\\"]

    reject_strs.each do |str|
      list_of_passengers = list_of_passengers.gsub(str, ' ')
    end
    
    list_of_passengers = list_of_passengers.split(' ')

    list_of_passengers&.each do |passenger|
      push("#{passenger}")
    end

    return self
  end

  def seating
    
    @seating || []
  end

  def pickup(passenger)
    return self if passenger.nil?

    push(passenger)
  end

  def self.collide(bus1, bus2)
    bus1_temp = array_content(bus1)
    bus2_temp = array_content(bus2)

    bus1.clear()
    bus2.clear()

    bus2_temp&.each do |passenger|
      bus1.push(passenger)
    end

    bus1_temp&.each do |passenger|
      bus2.push(passenger)
    end

    return bus1, bus2
  end

  # Find the largest number in the array and distribute to other seats in sequence.
  def self.reshuffle_seating(seating = [])
    seat_row_max = seating.length - 1
    max_pax = seating.max()
    max_pax_indx = seating.index(max_pax)

    # When Both Seats 1 and 4 have the max/highest passenger
    if seating[0] == max_pax && seating[3] == max_pax
      max_pax = seating[0] 
      max_pax_indx = 0
    end
    
    seat_row_loop = if seat_row_max == max_pax_indx
                      0 # Assigns loop to first seat
                    else 
                      max_pax_indx + 1
                    end

    seating[max_pax_indx] = 0

    # Loop for distributing pax across bus
    for i in 1..max_pax do
      seating[seat_row_loop] += 1

      seat_row_loop = if seat_row_loop == seat_row_max
                        0
                      else
                        seat_row_loop + 1
                      end
    end

    seating
  end

  def reshuffle_seating
    first_shuffle = MagicBus.reshuffle_seating(seating)
    @reshuffle_count = 1

    seating = MagicBus.reshuffle_seating(MagicBus.array_content(first_shuffle))
    @reshuffle_count += 1

    until seating == first_shuffle do
      p seating
      @reshuffle_count += 1

      seating = MagicBus.reshuffle_seating(seating)
    end
  end

  def reshuffle_count
    @reshuffle_count || 0
  end

  def move_passenger(passenger, new_placement)
    return self unless self.include? passenger

    placement_index = index(passenger) # To return passenger when there are no cases matched
    delete(passenger) # Removed temporarily 

    if new_placement.key?(:location)
      case new_placement[:location]
      when 'front'
        placement_index = 0
      when 'back'
        placement_index = -1
      end
    elsif new_placement.key?(:left_of)
      placement_index = index(new_placement[:left_of]) - 1
    end

    return insert(placement_index, passenger)
  end

  def dropoff( passengers = [] )
    return self if passengers.empty?

    passengers&.each do |passenger|
      delete( passenger )
    end
  end

  private

  def self.array_content(array)
    temp_array = []

    array&.each do |elem|
      temp_array.push(elem)
    end

    temp_array
  end

end

require 'minitest/autorun'
class TestMagicBus < MiniTest::Test

  def setup
    @bus = MagicBus.new(["Peter","James","Bardoe","Patrick","Jake","Samson","Dave"])
  end

  def test_move_the_last_passenger_to_the_front_of_the_bus
    assert_equal "Peter", @bus[0]
    @bus.move_passenger("Dave", location: 'front')
    assert_equal "Dave", @bus[0]
  end

  def test_move_the_middle_passenger_to_the_back_of_the_bus
    @bus.move_passenger("Patrick", location: 'back')
    assert_equal "Patrick", @bus[-1]
  end

  def test_pick_up_a_passenger_and_move_them_to_a_new_seat
    @bus.pickup("Mike")
    @bus.move_passenger("Mike", left_of: "Jake")
    @bus.move_passenger("Patrick", location: 'back')
    assert_equal ["Peter","James","Bardoe","Mike","Jake","Samson","Dave","Patrick"], @bus
  end

  def test_add_passengers_from_role
    bus = MagicBus.new
    bus.add_passengers_from_role('"Peter, James"  Bardoe\n"Mike;&Jake and   Samson\n\nDave",Patrick .')

    assert_equal ["Peter","James","Bardoe","Mike","Jake","Samson","Dave","Patrick"], bus
  end

  def test_two_magic_buses_collide_and_swap_their_passengers
    bus1 = MagicBus.new(["Mark","Dale","Peter"])
    bus1_object_id = bus1.object_id

    bus2 = MagicBus.new(["James","Patrick","Bardoe"])
    bus2_object_id = bus2.object_id

    MagicBus.collide(bus1, bus2)


    assert_equal ["James","Patrick","Bardoe"], bus1
    assert_equal bus1_object_id, bus1.object_id

    assert_equal ["Mark","Dale","Peter"], bus2
    assert_equal bus2_object_id, bus2.object_id
  end

  def test_unload_all_but_the_last_passenger
    @bus.dropoff(["Peter","James","Bardoe","Jake","Samson","Dave"])

    assert_equal ["Patrick"], @bus
  end
end

# The magic bus travels down a street and picks up passengers, the passengers
# are then reshuffled to distribute passengers away from the most popular seats on the bus.
#
# == LOGIC
# When distributing passengers the most popular seat is selected first
# The passengers are then distributed to seats starting with the next seat and continuing to the first, second, third
# and so on until the passengers are spread across the bus.
class TestMagicBusSeating < MiniTest::Test

  # The 3rd seat is chosen first (7)
  # 7 passengers are then distributed to seats, starting with the 4th seat, and looping back to the first
  # 0270 => 0201 => 1201 => 1301 => 1311 => 1312 => 2312 => 2412
  def test_reshuffle_seating1
    seating = MagicBus.reshuffle_seating([0,2,7,0])
    assert_equal([2, 4, 1, 2], seating)
  end

  # The 2nd seat is chosen first (4)
  # 4 passengers are then distributed to seats, starting with the 3rd seat
  def test_reshuffle_seating2
    seating = MagicBus.reshuffle_seating([2,4,1,2])
    assert_equal([3, 1, 2, 3], seating)
  end

  # Both the 1st and 4th seats tie, therefore the 1st seat is chosen (3).
  # 3 passengers are then distributed to seats, starting with the 2nd seat
  def test_reshuffle_seating3
    seating = MagicBus.reshuffle_seating([3,1,2,3])
    assert_equal([0,2,3,4], seating)
  end

  # The 4th seat is chosen first (4)
  # 4 passengers are then distributed to seats, starting with the 1st seat
  def test_reshuffle_seating4
    seating = MagicBus.reshuffle_seating([0,2,3,4])
    assert_equal([1, 3, 4, 1], seating)
  end

  # The 3rd seat is chosen and the same thing happens.
  def test_reshuffle_seating5
    seating = MagicBus.reshuffle_seating([1,3,4,1])
    assert_equal([2, 4, 1, 2], seating)
  end

  # Putting tests 1-5 together we produce a count of how many reshuffles are required
  # before we encounter an arrangement we have previously had.
  #  MagicBus.reshuffle_seating([0,2,7,0]) # [2,4,1,2] *
  #  MagicBus.reshuffle_seating([2,4,1,2]) # [3,1,2,3]
  #  MagicBus.reshuffle_seating([3,1,2,3]) # [0,2,3,4]
  #  MagicBus.reshuffle_seating([0,2,3,4]) # [1,3,4,1]
  #  MagicBus.reshuffle_seating([1,3,4,1]) # [2 4,1,2] *
  #  => 5 reshuffles
  def test_reshuffle_seating_instance1
    bus = MagicBus.new
    bus.seating = [0,2,7,0]
    bus.reshuffle_seating

    assert_equal([2, 4, 1, 2], bus.seating)
    assert_equal(5, bus.reshuffle_count)
  end

  # def test_reshuffle_seating_instance2
  #   bus = MagicBus.new
  #   bus.seating = [5,1,10,0,1,7,13,14,3,12,8,10,7,12,0,6]
  #   bus.reshuffle_seating

  #   # complete this test - what is 'num'?
  #   # TODO replace bus.reshuffle_count with number of tries it would take to encounter a previous arrangement
  #   num = bus.reshuffle_count
  #   assert_equal(num, 1)
  # end

end
