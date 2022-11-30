# For User Inputs, uncomment the line on the bottom of this file

#!/usr/bin/env ruby
require 'json'

class Airplane < Array
  attr_accessor :seating, :max_row

  def initialize(seating)
    @seating = seating
    self.max_row = 0

    initialize_seat
  end

  def initialize_seat
    new_seating = []

    @seating.each do |seat|
      row = seat[1]
      column = seat[0]
      seat_row = []

      self.max_row = row if row > self.max_row # Get the max col for array count

      # Loop thru 2D array and initialize seats
      for x in 1..row
        seat_column = []

        for y in 1..column
          seat_column << {filled: false}
        end

        seat_row << seat_column
      end

      new_seating << seat_row
    end

    self.seating = new_seating
  end

  def passenger(passengers)
    return @seating if passengers.zero?

    seated_passengers = seat_to(passengers, aisle: true)
    seated_passengers = seat_to(passengers, window: true, seated_passengers: seated_passengers) unless seated_passengers == passengers 
    seated_passengers = seat_to(passengers, seated_passengers: seated_passengers) unless seated_passengers == passengers

    true
  end

  def seat_to(passengers, seated_passengers: 0, aisle: false, window: false)
    for i in 0..self.max_row - 1
      self.seating.each_with_index do |seat, idx|
        next if seat[i].nil?

        seat[i].each_with_index do |col_seat, col_idx|
          next if col_seat[:filled]
          # Determine seat location
          is_window = (idx == 0 && col_idx == 0) || (idx == self.seating.count - 1 && col_idx == seat[i].count - 1)
          is_aisle = is_window ? false : col_idx == 0 || col_idx == seat[i].count - 1

          if aisle && is_aisle
            col_seat[:filled] = true
            seated_passengers += 1
          elsif window && is_window
            col_seat[:filled] = true
            seated_passengers += 1
          elsif !aisle && !window && !is_window && !is_aisle
            col_seat[:filled] = true
            seated_passengers += 1
          end
      
          break if seated_passengers == passengers
        end

        break if seated_passengers == passengers
      end

      break if seated_passengers == passengers
    end

    seated_passengers
  end
end

require 'minitest/autorun'
class TestAirplane < MiniTest::Test
  def test_initialize
    @airplane = Airplane.new([[1,2],[2,3]])

    assert_equal [[{filled: false}], [{filled: false}]], @airplane.seating.first
    assert_equal [[{filled: false}, {filled: false}], 
                  [{filled: false}, {filled: false}], 
                  [{filled: false}, {filled: false}]], @airplane.seating.last
  end

  def test_seating_passengers
    @airplane = Airplane.new([[1,2],[2,3]])
    @airplane.passenger(8)

    assert_equal [[{filled: true}], [{filled: true}]], @airplane.seating.first
    assert_equal [[{filled: true}, {filled: true}], 
                  [{filled: true}, {filled: true}], 
                  [{filled: true}, {filled: true}]], @airplane.seating.last
  end

  def test_seat_hierarchy_aisle
    @airplane = Airplane.new([[1,2],[2,3]])
    @airplane.passenger(3)

    assert_equal [[{filled: false}], [{filled: false}]], @airplane.seating.first
    assert_equal [[{filled: true}, {filled: false}], 
                  [{filled: true}, {filled: false}], 
                  [{filled: true}, {filled: false}]], @airplane.seating.last
  end

  def test_seat_hierarchy_window
    @airplane = Airplane.new([[1,2],[2,3]])
    @airplane.passenger(6)

    assert_equal [[{filled: true}], [{filled: true}]], @airplane.seating.first
    assert_equal [[{filled: true}, {filled: true}], 
                  [{filled: true}, {filled: false}], 
                  [{filled: true}, {filled: false}]], @airplane.seating.last
  end

  def test_seat_hierarchy_middle
    @airplane = Airplane.new([[1,2],[3,2]])
    @airplane.passenger(7)

    assert_equal [[{filled: true}], [{filled: true}]], @airplane.seating.first
    assert_equal [[{filled: true}, {filled: true}, {filled: true}], 
                  [{filled: true}, {filled: false}, {filled: true}]], @airplane.seating.last
  end

  def test_seating_passengers_sample
    @airplane = Airplane.new([[3,2],[4,3],[2,3],[3,4]])
    @airplane.passenger(30)

    # First seat array
    assert_equal [[{filled: true}, {filled: true}, {filled: true}], 
                  [{filled: true}, {filled: true}, {filled: true}]], @airplane.seating[0]

    # Second seat array
    assert_equal [[{filled: true}, {filled: true}, {filled: true}, {filled: true}], 
                  [{filled: true}, {filled: true}, {filled: false}, {filled: true}], 
                  [{filled: true}, {filled: false}, {filled: false}, {filled: true}]], @airplane.seating[1]

    # Third seat array
    assert_equal [[{filled: true}, {filled: true}], 
                  [{filled: true}, {filled: true}], 
                  [{filled: true}, {filled: true}]], @airplane.seating[2]

    # Fourth seat array
    assert_equal [[{filled: true}, {filled: true}, {filled: true}], 
                  [{filled: true}, {filled: false}, {filled: true}], 
                  [{filled: true}, {filled: false}, {filled: true}], 
                  [{filled: true}, {filled: false}, {filled: true}]], @airplane.seating[3]
  end
end

puts 'Represent Airplane seating.'
puts 'Input 2D array(format: [[1,2],[2,3]..]):'
usr_input = gets
arr = JSON.parse usr_input

user_airplane = Airplane.new(arr)
puts 'How many passengers?'
usr_passenger = gets
user_airplane.passenger(usr_passenger.to_i)
p 'Airplane Seating(2D Array Representation):', user_airplane.seating
