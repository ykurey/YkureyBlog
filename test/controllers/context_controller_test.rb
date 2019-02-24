require 'test_helper'

class ContextControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get context_index_url
    assert_response :success
  end

end
