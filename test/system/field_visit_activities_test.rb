require "application_system_test_case"

class FieldVisitActivitiesTest < ApplicationSystemTestCase
  setup do
    @field_visit_activity = field_visit_activities(:one)
  end

  test "visiting the index" do
    visit field_visit_activities_url
    assert_selector "h1", text: "Field visit activities"
  end

  test "should create field visit activity" do
    visit field_visit_activities_url
    click_on "New field visit activity"

    fill_in "Description", with: @field_visit_activity.description
    fill_in "Duration", with: @field_visit_activity.duration
    fill_in "Field visit area", with: @field_visit_activity.field_visit_area_id
    fill_in "Max participants", with: @field_visit_activity.max_participants
    fill_in "Name", with: @field_visit_activity.name
    fill_in "Notes", with: @field_visit_activity.notes
    fill_in "Scheduled date", with: @field_visit_activity.scheduled_date
    click_on "Create Field visit activity"

    assert_text "Field visit activity was successfully created"
    click_on "Back"
  end

  test "should update Field visit activity" do
    visit field_visit_activity_url(@field_visit_activity)
    click_on "Edit this field visit activity", match: :first

    fill_in "Description", with: @field_visit_activity.description
    fill_in "Duration", with: @field_visit_activity.duration
    fill_in "Field visit area", with: @field_visit_activity.field_visit_area_id
    fill_in "Max participants", with: @field_visit_activity.max_participants
    fill_in "Name", with: @field_visit_activity.name
    fill_in "Notes", with: @field_visit_activity.notes
    fill_in "Scheduled date", with: @field_visit_activity.scheduled_date
    click_on "Update Field visit activity"

    assert_text "Field visit activity was successfully updated"
    click_on "Back"
  end

  test "should destroy Field visit activity" do
    visit field_visit_activity_url(@field_visit_activity)
    click_on "Destroy this field visit activity", match: :first

    assert_text "Field visit activity was successfully destroyed"
  end
end
