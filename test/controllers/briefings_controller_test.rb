require 'test_helper'

class BriefingsControllerTest < ActionController::TestCase
  setup do
    @briefing = briefings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:briefings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create briefing" do
    assert_difference('Briefing.count') do
      post :create, briefing: { about: @briefing.about, company: @briefing.company, email: @briefing.email, name: @briefing.name, other: @briefing.other, phone: @briefing.phone, services_type: @briefing.services_type }
    end

    assert_redirected_to briefing_path(assigns(:briefing))
  end

  test "should show briefing" do
    get :show, id: @briefing
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @briefing
    assert_response :success
  end

  test "should update briefing" do
    patch :update, id: @briefing, briefing: { about: @briefing.about, company: @briefing.company, email: @briefing.email, name: @briefing.name, other: @briefing.other, phone: @briefing.phone, services_type: @briefing.services_type }
    assert_redirected_to briefing_path(assigns(:briefing))
  end

  test "should destroy briefing" do
    assert_difference('Briefing.count', -1) do
      delete :destroy, id: @briefing
    end

    assert_redirected_to briefings_path
  end
end
