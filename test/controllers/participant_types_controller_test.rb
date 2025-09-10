require "test_helper"

class ParticipantTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @participant_type = participant_types(:one)
  end

  test "should get index" do
    get participant_types_url
    assert_response :success
  end

  test "should get new" do
    get new_participant_type_url
    assert_response :success
  end

  test "should create participant_type" do
    assert_difference("ParticipantType.count") do
      post participant_types_url, params: { participant_type: { description: @participant_type.description, type_name: @participant_type.type_name } }
    end

    assert_redirected_to participant_type_url(ParticipantType.last)
  end

  test "should show participant_type" do
    get participant_type_url(@participant_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_participant_type_url(@participant_type)
    assert_response :success
  end

  test "should update participant_type" do
    patch participant_type_url(@participant_type), params: { participant_type: { description: @participant_type.description, type_name: @participant_type.type_name } }
    assert_redirected_to participant_type_url(@participant_type)
  end

  test "should destroy participant_type" do
    assert_difference("ParticipantType.count", -1) do
      delete participant_type_url(@participant_type)
    end

    assert_redirected_to participant_types_url
  end
end
