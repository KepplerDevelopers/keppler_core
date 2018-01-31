require 'test_helper'

class RockersControllerTest < ActionController::TestCase
  setup do
    @rocker = rockers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rockers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rocker" do
    assert_difference('Rocker.count') do
      post :create, rocker: { avatar: @rocker.avatar, name: @rocker.name }
    end

    assert_redirected_to rocker_path(assigns(:rocker))
  end

  test "should show rocker" do
    get :show, id: @rocker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rocker
    assert_response :success
  end

  test "should update rocker" do
    patch :update, id: @rocker, rocker: { avatar: @rocker.avatar, name: @rocker.name }
    assert_redirected_to rocker_path(assigns(:rocker))
  end

  test "should destroy rocker" do
    assert_difference('Rocker.count', -1) do
      delete :destroy, id: @rocker
    end

    assert_redirected_to rockers_path
  end
end
