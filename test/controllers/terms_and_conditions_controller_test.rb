require 'test_helper'

class TermsAndConditionsControllerTest < ActionController::TestCase
  setup do
    @terms_and_condition = terms_and_conditions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:terms_and_conditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create terms_and_condition" do
    assert_difference('TermsAndCondition.count') do
      post :create, terms_and_condition: { content: @terms_and_condition.content }
    end

    assert_redirected_to terms_and_condition_path(assigns(:terms_and_condition))
  end

  test "should show terms_and_condition" do
    get :show, id: @terms_and_condition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @terms_and_condition
    assert_response :success
  end

  test "should update terms_and_condition" do
    patch :update, id: @terms_and_condition, terms_and_condition: { content: @terms_and_condition.content }
    assert_redirected_to terms_and_condition_path(assigns(:terms_and_condition))
  end

  test "should destroy terms_and_condition" do
    assert_difference('TermsAndCondition.count', -1) do
      delete :destroy, id: @terms_and_condition
    end

    assert_redirected_to terms_and_conditions_path
  end
end
