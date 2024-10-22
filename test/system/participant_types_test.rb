require "application_system_test_case"

class ParticipantTypesTest < ApplicationSystemTestCase
  setup do
    @participant_type = participant_types(:one)
  end

  test "visiting the index" do
    visit participant_types_url
    assert_selector "h1", text: "Participant types"
  end

  test "should create participant type" do
    visit participant_types_url
    click_on "New participant type"

    fill_in "Description", with: @participant_type.description
    fill_in "Type name", with: @participant_type.type_name
    click_on "Create Participant type"

    assert_text "Participant type was successfully created"
    click_on "Back"
  end

  test "should update Participant type" do
    visit participant_type_url(@participant_type)
    click_on "Edit this participant type", match: :first

    fill_in "Description", with: @participant_type.description
    fill_in "Type name", with: @participant_type.type_name
    click_on "Update Participant type"

    assert_text "Participant type was successfully updated"
    click_on "Back"
  end

  test "should destroy Participant type" do
    visit participant_type_url(@participant_type)
    click_on "Destroy this participant type", match: :first

    assert_text "Participant type was successfully destroyed"
  end
end
