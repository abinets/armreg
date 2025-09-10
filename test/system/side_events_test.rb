require "application_system_test_case"

class SideEventsTest < ApplicationSystemTestCase
  setup do
    @side_event = side_events(:one)
  end

  test "visiting the index" do
    visit side_events_url
    assert_selector "h1", text: "Side events"
  end

  test "should create side event" do
    visit side_events_url
    click_on "New side event"

    fill_in "Description", with: @side_event.description
    fill_in "Enddate", with: @side_event.enddate
    fill_in "Event name", with: @side_event.event_name
    fill_in "Startdate", with: @side_event.startdate
    fill_in "Venue", with: @side_event.venue
    click_on "Create Side event"

    assert_text "Side event was successfully created"
    click_on "Back"
  end

  test "should update Side event" do
    visit side_event_url(@side_event)
    click_on "Edit this side event", match: :first

    fill_in "Description", with: @side_event.description
    fill_in "Enddate", with: @side_event.enddate
    fill_in "Event name", with: @side_event.event_name
    fill_in "Startdate", with: @side_event.startdate
    fill_in "Venue", with: @side_event.venue
    click_on "Update Side event"

    assert_text "Side event was successfully updated"
    click_on "Back"
  end

  test "should destroy Side event" do
    visit side_event_url(@side_event)
    click_on "Destroy this side event", match: :first

    assert_text "Side event was successfully destroyed"
  end
end
