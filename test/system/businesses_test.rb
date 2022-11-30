require "application_system_test_case"

class BusinessesTest < ApplicationSystemTestCase
  setup do
    @business = businesses(:one)
  end

  test "visiting the index" do
    visit businesses_url
    assert_selector "h1", text: "Businesses"
  end

  test "should create business" do
    visit businesses_url
    click_on "New business"

    fill_in "Abn", with: @business.abn
    fill_in "Address", with: @business.address
    fill_in "Bus desc1", with: @business.bus_desc1
    fill_in "Email", with: @business.email
    fill_in "Fax", with: @business.fax
    fill_in "Location", with: @business.location
    fill_in "Mobile", with: @business.mobile
    fill_in "Num of emp", with: @business.num_of_emp
    fill_in "Organisation", with: @business.organisation
    fill_in "Phone", with: @business.phone
    fill_in "Postcode", with: @business.postcode
    fill_in "Region", with: @business.region
    fill_in "State", with: @business.state
    fill_in "Tollfree", with: @business.tollfree
    fill_in "Website", with: @business.website
    click_on "Create Business"

    assert_text "Business was successfully created"
    click_on "Back"
  end

  test "should update Business" do
    visit business_url(@business)
    click_on "Edit this business", match: :first

    fill_in "Abn", with: @business.abn
    fill_in "Address", with: @business.address
    fill_in "Bus desc1", with: @business.bus_desc1
    fill_in "Email", with: @business.email
    fill_in "Fax", with: @business.fax
    fill_in "Location", with: @business.location
    fill_in "Mobile", with: @business.mobile
    fill_in "Num of emp", with: @business.num_of_emp
    fill_in "Organisation", with: @business.organisation
    fill_in "Phone", with: @business.phone
    fill_in "Postcode", with: @business.postcode
    fill_in "Region", with: @business.region
    fill_in "State", with: @business.state
    fill_in "Tollfree", with: @business.tollfree
    fill_in "Website", with: @business.website
    click_on "Update Business"

    assert_text "Business was successfully updated"
    click_on "Back"
  end

  test "should destroy Business" do
    visit business_url(@business)
    click_on "Destroy this business", match: :first

    assert_text "Business was successfully destroyed"
  end
end
