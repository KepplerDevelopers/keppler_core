require 'test_helper'

class AdminControllerTest < ActionController::TestCase   

  test "should get dashboard" do
  	sign_in users(:admin)
    get :dashboard
    assert_response :success
  end

end
