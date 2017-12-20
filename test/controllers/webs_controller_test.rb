require 'test_helper'

class WebsControllerTest < ActionController::TestCase
  setup do
    @web = webs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create web" do
    assert_difference('Web.count') do
      post :create, web: { headline: @web.headline, name: @web.name }
    end

    assert_redirected_to web_path(assigns(:web))
  end

  test "should show web" do
    get :show, id: @web
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @web
    assert_response :success
  end

  test "should update web" do
    patch :update, id: @web, web: { headline: @web.headline, name: @web.name }
    assert_redirected_to web_path(assigns(:web))
  end

  test "should destroy web" do
    assert_difference('Web.count', -1) do
      delete :destroy, id: @web
    end

    assert_redirected_to webs_path
  end
end
