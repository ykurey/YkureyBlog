require 'test_helper'

class SigninsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signins_new_url
    assert_response :success
  end

end
