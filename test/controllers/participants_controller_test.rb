require "test_helper"

class ParticipantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @participant = participants(:one)
  end

  test "should get index" do
    get participants_url
    assert_response :success
  end

  test "should get new" do
    get new_participant_url
    assert_response :success
  end

  test "should create participant" do
    assert_difference("Participant.count") do
      post participants_url, params: { participant: { accommodation_required: @participant.accommodation_required, email: @participant.email, emergency_contact_name: @participant.emergency_contact_name, emergency_contact_number: @participant.emergency_contact_number, group_id: @participant.group_id, location: @participant.location, meal_options: @participant.meal_options, name: @participant.name, notes: @participant.notes, organization_id: @participant.organization_id, participant_type_id: @participant.participant_type_id, position: @participant.position, registration_date: @participant.registration_date, resourceMaterial_take: @participant.resourceMaterial_take, side_event_id: @participant.side_event_id, telephone_number: @participant.telephone_number } }
    end

    assert_redirected_to participant_url(Participant.last)
  end

  test "should show participant" do
    get participant_url(@participant)
    assert_response :success
  end

  test "should get edit" do
    get edit_participant_url(@participant)
    assert_response :success
  end

  test "should update participant" do
    patch participant_url(@participant), params: { participant: { accommodation_required: @participant.accommodation_required, email: @participant.email, emergency_contact_name: @participant.emergency_contact_name, emergency_contact_number: @participant.emergency_contact_number, group_id: @participant.group_id, location: @participant.location, meal_options: @participant.meal_options, name: @participant.name, notes: @participant.notes, organization_id: @participant.organization_id, participant_type_id: @participant.participant_type_id, position: @participant.position, registration_date: @participant.registration_date, resourceMaterial_take: @participant.resourceMaterial_take, side_event_id: @participant.side_event_id, telephone_number: @participant.telephone_number } }
    assert_redirected_to participant_url(@participant)
  end

  test "should destroy participant" do
    assert_difference("Participant.count", -1) do
      delete participant_url(@participant)
    end

    assert_redirected_to participants_url
  end
end
