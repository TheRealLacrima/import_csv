require "test_helper"

class BusinessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business = businesses(:one)
  end

  test "should get index" do
    get businesses_url
    assert_response :success
  end

  test "should get new" do
    get new_business_url
    assert_response :success
  end

  test "should create business" do
    assert_difference("Business.count") do
      post businesses_url, params: { business: { abn: @business.abn, address: @business.address, bus_desc1: @business.bus_desc1, email: @business.email, fax: @business.fax, location: @business.location, mobile: @business.mobile, num_of_emp: @business.num_of_emp, organisation: @business.organisation, phone: @business.phone, postcode: @business.postcode, region: @business.region, state: @business.state, tollfree: @business.tollfree, website: @business.website } }
    end

    assert_redirected_to business_url(Business.last)
  end

  test "should show business" do
    get business_url(@business)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_url(@business)
    assert_response :success
  end

  test "should update business" do
    patch business_url(@business), params: { business: { abn: @business.abn, address: @business.address, bus_desc1: @business.bus_desc1, email: @business.email, fax: @business.fax, location: @business.location, mobile: @business.mobile, num_of_emp: @business.num_of_emp, organisation: @business.organisation, phone: @business.phone, postcode: @business.postcode, region: @business.region, state: @business.state, tollfree: @business.tollfree, website: @business.website } }
    assert_redirected_to business_url(@business)
  end

  test "should destroy business" do
    assert_difference("Business.count", -1) do
      delete business_url(@business)
    end

    assert_redirected_to businesses_url
  end
end
