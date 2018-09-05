require 'test_helper'

class UsersControllerTest < ActionController::TestCase
	test "should get index" do
		sign_in users(:admin)
		get :index
		assert_not_includes assigns(:users), users(:admin), "ERROR, no debe venir current_user en la colección"
		assert_response :success
	end

	test "should refresh user list" do
		sign_in users(:admin)
		get :refresh
		assert_not_includes assigns(:users), users(:admin), "ERROR, no debe venir current_user en la colección"
		assert_response :success
	end

end
