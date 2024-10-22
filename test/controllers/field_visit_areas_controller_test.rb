require "test_helper"

class FieldVisitAreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @field_visit_area = field_visit_areas(:one)
  end

  test "should get index" do
    get field_visit_areas_url
    assert_response :success
  end

  test "should get new" do
    get new_field_visit_area_url
    assert_response :success
  end

  test "should create field_visit_area" do
    assert_difference("FieldVisitArea.count") do
      post field_visit_areas_url, params: { field_visit_area: { distance_from_arm_venue: @field_visit_area.distance_from_arm_venue, name: @field_visit_area.name, note: @field_visit_area.note } }
    end

    assert_redirected_to field_visit_area_url(FieldVisitArea.last)
  end

  test "should show field_visit_area" do
    get field_visit_area_url(@field_visit_area)
    assert_response :success
  end

  test "should get edit" do
    get edit_field_visit_area_url(@field_visit_area)
    assert_response :success
  end

  test "should update field_visit_area" do
    patch field_visit_area_url(@field_visit_area), params: { field_visit_area: { distance_from_arm_venue: @field_visit_area.distance_from_arm_venue, name: @field_visit_area.name, note: @field_visit_area.note } }
    assert_redirected_to field_visit_area_url(@field_visit_area)
  end

  test "should destroy field_visit_area" do
    assert_difference("FieldVisitArea.count", -1) do
      delete field_visit_area_url(@field_visit_area)
    end

    assert_redirected_to field_visit_areas_url
  end
end
