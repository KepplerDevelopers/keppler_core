require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "should get not_authorized" do
    get :not_authorized
    assert_response :success
  end

  test "should get file_not_found" do
    get :file_not_found
    assert_response :success
  end

  test "should get unprocessable" do
    get :unprocessable
    assert_response :success
  end

  test "should get internal_server_error" do
    get :internal_server_error
    assert_response :success
  end

end
