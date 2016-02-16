require 'test_helper'

class GoogleAdwordsControllerTest < ActionController::TestCase
  setup do
    @google_adword = google_adwords(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:google_adwords)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create google_adword" do
    assert_difference('GoogleAdword.count') do
      post :create, google_adword: { campaign_name: @google_adword.campaign_name, description: @google_adword.description, script: @google_adword.script, url: @google_adword.url }
    end

    assert_redirected_to google_adword_path(assigns(:google_adword))
  end

  test "should show google_adword" do
    get :show, id: @google_adword
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @google_adword
    assert_response :success
  end

  test "should update google_adword" do
    patch :update, id: @google_adword, google_adword: { campaign_name: @google_adword.campaign_name, description: @google_adword.description, script: @google_adword.script, url: @google_adword.url }
    assert_redirected_to google_adword_path(assigns(:google_adword))
  end

  test "should destroy google_adword" do
    assert_difference('GoogleAdword.count', -1) do
      delete :destroy, id: @google_adword
    end

    assert_redirected_to google_adwords_path
  end
end
