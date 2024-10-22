require "test_helper"

class FieldVisitActivitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @field_visit_activity = field_visit_activities(:one)
  end

  test "should get index" do
    get field_visit_activities_url
    assert_response :success
  end

  test "should get new" do
    get new_field_visit_activity_url
    assert_response :success
  end

  test "should create field_visit_activity" do
    assert_difference("FieldVisitActivity.count") do
      post field_visit_activities_url, params: { field_visit_activity: { description: @field_visit_activity.description, duration: @field_visit_activity.duration, field_visit_area_id: @field_visit_activity.field_visit_area_id, max_participants: @field_visit_activity.max_participants, name: @field_visit_activity.name, notes: @field_visit_activity.notes, scheduled_date: @field_visit_activity.scheduled_date } }
    end

    assert_redirected_to field_visit_activity_url(FieldVisitActivity.last)
  end

  test "should show field_visit_activity" do
    get field_visit_activity_url(@field_visit_activity)
    assert_response :success
  end

  test "should get edit" do
    get edit_field_visit_activity_url(@field_visit_activity)
    assert_response :success
  end

  test "should update field_visit_activity" do
    patch field_visit_activity_url(@field_visit_activity), params: { field_visit_activity: { description: @field_visit_activity.description, duration: @field_visit_activity.duration, field_visit_area_id: @field_visit_activity.field_visit_area_id, max_participants: @field_visit_activity.max_participants, name: @field_visit_activity.name, notes: @field_visit_activity.notes, scheduled_date: @field_visit_activity.scheduled_date } }
    assert_redirected_to field_visit_activity_url(@field_visit_activity)
  end

  test "should destroy field_visit_activity" do
    assert_difference("FieldVisitActivity.count", -1) do
      delete field_visit_activity_url(@field_visit_activity)
    end

    assert_redirected_to field_visit_activities_url
  end
end
