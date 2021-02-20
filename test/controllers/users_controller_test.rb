require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get register" do
    get register_url
    assert_response :success
    assert_select 'title', "#{Globals::App::TITLE} | Registration"
  end

end
