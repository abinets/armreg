require "test_helper"

class AdminParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_participants_index_url
    assert_response :success
  end

  test "should get approve" do
    get admin_participants_approve_url
    assert_response :success
  end

  test "should get reject" do
    get admin_participants_reject_url
    assert_response :success
  end
end
