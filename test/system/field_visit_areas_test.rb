require "application_system_test_case"

class FieldVisitAreasTest < ApplicationSystemTestCase
  setup do
    @field_visit_area = field_visit_areas(:one)
  end

  test "visiting the index" do
    visit field_visit_areas_url
    assert_selector "h1", text: "Field visit areas"
  end

  test "should create field visit area" do
    visit field_visit_areas_url
    click_on "New field visit area"

    fill_in "Distance from arm venue", with: @field_visit_area.distance_from_arm_venue
    fill_in "Name", with: @field_visit_area.name
    fill_in "Note", with: @field_visit_area.note
    click_on "Create Field visit area"

    assert_text "Field visit area was successfully created"
    click_on "Back"
  end

  test "should update Field visit area" do
    visit field_visit_area_url(@field_visit_area)
    click_on "Edit this field visit area", match: :first

    fill_in "Distance from arm venue", with: @field_visit_area.distance_from_arm_venue
    fill_in "Name", with: @field_visit_area.name
    fill_in "Note", with: @field_visit_area.note
    click_on "Update Field visit area"

    assert_text "Field visit area was successfully updated"
    click_on "Back"
  end

  test "should destroy Field visit area" do
    visit field_visit_area_url(@field_visit_area)
    click_on "Destroy this field visit area", match: :first

    assert_text "Field visit area was successfully destroyed"
  end
end
