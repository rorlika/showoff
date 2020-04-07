require 'test_helper'

class UserWidgetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_widgets_index_url
    assert_response :success
  end

end
