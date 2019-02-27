require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_up" do
    get users_sign_up_url
    assert_response :success
  end

  test "should get log_in" do
    get users_log_in_url
    assert_response :success
  end

  test "should get log_out" do
    get users_log_out_url
    assert_response :success
  end

end
