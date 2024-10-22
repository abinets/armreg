require "application_system_test_case"

class AttendeesTest < ApplicationSystemTestCase
  setup do
    @attendee = attendees(:one)
  end

  test "visiting the index" do
    visit attendees_url
    assert_selector "h1", text: "Attendees"
  end

  test "should create attendee" do
    visit attendees_url
    click_on "New attendee"

    fill_in "Address", with: @attendee.address
    fill_in "Days to attend", with: @attendee.days_to_attend
    fill_in "Full name", with: @attendee.full_name
    fill_in "Org", with: @attendee.org
    click_on "Create Attendee"

    assert_text "Attendee was successfully created"
    click_on "Back"
  end

  test "should update Attendee" do
    visit attendee_url(@attendee)
    click_on "Edit this attendee", match: :first

    fill_in "Address", with: @attendee.address
    fill_in "Days to attend", with: @attendee.days_to_attend
    fill_in "Full name", with: @attendee.full_name
    fill_in "Org", with: @attendee.org
    click_on "Update Attendee"

    assert_text "Attendee was successfully updated"
    click_on "Back"
  end

  test "should destroy Attendee" do
    visit attendee_url(@attendee)
    click_on "Destroy this attendee", match: :first

    assert_text "Attendee was successfully destroyed"
  end
end
