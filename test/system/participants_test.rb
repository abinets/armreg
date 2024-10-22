require "application_system_test_case"

class ParticipantsTest < ApplicationSystemTestCase
  setup do
    @participant = participants(:one)
  end

  test "visiting the index" do
    visit participants_url
    assert_selector "h1", text: "Participants"
  end

  test "should create participant" do
    visit participants_url
    click_on "New participant"

    check "Accommodation required" if @participant.accommodation_required
    fill_in "Email", with: @participant.email
    fill_in "Emergency contact name", with: @participant.emergency_contact_name
    fill_in "Emergency contact number", with: @participant.emergency_contact_number
    fill_in "Group", with: @participant.group_id
    fill_in "Location", with: @participant.location
    fill_in "Meal options", with: @participant.meal_options
    fill_in "Name", with: @participant.name
    fill_in "Notes", with: @participant.notes
    fill_in "Organization", with: @participant.organization_id
    fill_in "Participant type", with: @participant.participant_type_id
    fill_in "Position", with: @participant.position
    fill_in "Registration date", with: @participant.registration_date
    check "Resourcematerial take" if @participant.resourceMaterial_take
    fill_in "Side event", with: @participant.side_event_id
    fill_in "Telephone number", with: @participant.telephone_number
    click_on "Create Participant"

    assert_text "Participant was successfully created"
    click_on "Back"
  end

  test "should update Participant" do
    visit participant_url(@participant)
    click_on "Edit this participant", match: :first

    check "Accommodation required" if @participant.accommodation_required
    fill_in "Email", with: @participant.email
    fill_in "Emergency contact name", with: @participant.emergency_contact_name
    fill_in "Emergency contact number", with: @participant.emergency_contact_number
    fill_in "Group", with: @participant.group_id
    fill_in "Location", with: @participant.location
    fill_in "Meal options", with: @participant.meal_options
    fill_in "Name", with: @participant.name
    fill_in "Notes", with: @participant.notes
    fill_in "Organization", with: @participant.organization_id
    fill_in "Participant type", with: @participant.participant_type_id
    fill_in "Position", with: @participant.position
    fill_in "Registration date", with: @participant.registration_date
    check "Resourcematerial take" if @participant.resourceMaterial_take
    fill_in "Side event", with: @participant.side_event_id
    fill_in "Telephone number", with: @participant.telephone_number
    click_on "Update Participant"

    assert_text "Participant was successfully updated"
    click_on "Back"
  end

  test "should destroy Participant" do
    visit participant_url(@participant)
    click_on "Destroy this participant", match: :first

    assert_text "Participant was successfully destroyed"
  end
end
