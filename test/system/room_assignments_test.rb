require "application_system_test_case"

class RoomAssignmentsTest < ApplicationSystemTestCase
  setup do
    @room_assignment = room_assignments(:one)
  end

  test "visiting the index" do
    visit room_assignments_url
    assert_selector "h1", text: "Room assignments"
  end

  test "should create room assignment" do
    visit room_assignments_url
    click_on "New room assignment"

    fill_in "Arrived date", with: @room_assignment.arrived_date
    fill_in "Checkin date", with: @room_assignment.checkin_date
    fill_in "Checkout date", with: @room_assignment.checkout_date
    fill_in "Notes", with: @room_assignment.notes
    fill_in "Participant", with: @room_assignment.participant_id
    fill_in "Room", with: @room_assignment.room_id
    click_on "Create Room assignment"

    assert_text "Room assignment was successfully created"
    click_on "Back"
  end

  test "should update Room assignment" do
    visit room_assignment_url(@room_assignment)
    click_on "Edit this room assignment", match: :first

    fill_in "Arrived date", with: @room_assignment.arrived_date
    fill_in "Checkin date", with: @room_assignment.checkin_date
    fill_in "Checkout date", with: @room_assignment.checkout_date
    fill_in "Notes", with: @room_assignment.notes
    fill_in "Participant", with: @room_assignment.participant_id
    fill_in "Room", with: @room_assignment.room_id
    click_on "Update Room assignment"

    assert_text "Room assignment was successfully updated"
    click_on "Back"
  end

  test "should destroy Room assignment" do
    visit room_assignment_url(@room_assignment)
    click_on "Destroy this room assignment", match: :first

    assert_text "Room assignment was successfully destroyed"
  end
end
