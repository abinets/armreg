require "test_helper"

class SideEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @side_event = side_events(:one)
  end

  test "should get index" do
    get side_events_url
    assert_response :success
  end

  test "should get new" do
    get new_side_event_url
    assert_response :success
  end

  test "should create side_event" do
    assert_difference("SideEvent.count") do
      post side_events_url, params: { side_event: { description: @side_event.description, enddate: @side_event.enddate, event_name: @side_event.event_name, startdate: @side_event.startdate, venue: @side_event.venue } }
    end

    assert_redirected_to side_event_url(SideEvent.last)
  end

  test "should show side_event" do
    get side_event_url(@side_event)
    assert_response :success
  end

  test "should get edit" do
    get edit_side_event_url(@side_event)
    assert_response :success
  end

  test "should update side_event" do
    patch side_event_url(@side_event), params: { side_event: { description: @side_event.description, enddate: @side_event.enddate, event_name: @side_event.event_name, startdate: @side_event.startdate, venue: @side_event.venue } }
    assert_redirected_to side_event_url(@side_event)
  end

  test "should destroy side_event" do
    assert_difference("SideEvent.count", -1) do
      delete side_event_url(@side_event)
    end

    assert_redirected_to side_events_url
  end
end
