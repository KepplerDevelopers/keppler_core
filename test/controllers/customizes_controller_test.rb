require 'test_helper'

class CustomizesControllerTest < ActionController::TestCase
  setup do
    @customize = customizes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customizes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customize" do
    assert_difference('Customize.count') do
      post :create, customize: { file: @customize.file }
    end

    assert_redirected_to customize_path(assigns(:customize))
  end

  test "should show customize" do
    get :show, id: @customize
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customize
    assert_response :success
  end

  test "should update customize" do
    patch :update, id: @customize, customize: { file: @customize.file }
    assert_redirected_to customize_path(assigns(:customize))
  end

  test "should destroy customize" do
    assert_difference('Customize.count', -1) do
      delete :destroy, id: @customize
    end

    assert_redirected_to customizes_path
  end
end
