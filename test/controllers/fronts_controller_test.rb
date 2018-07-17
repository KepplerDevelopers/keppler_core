require 'test_helper'

class FrontsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @front = fronts(:one)
  end

  test "should get index" do
    get fronts_url
    assert_response :success
  end

  test "should get new" do
    get new_front_url
    assert_response :success
  end

  test "should create front" do
    assert_difference('Front.count') do
      post fronts_url, params: { front: { index: @front.index } }
    end

    assert_redirected_to front_url(Front.last)
  end

  test "should show front" do
    get front_url(@front)
    assert_response :success
  end

  test "should get edit" do
    get edit_front_url(@front)
    assert_response :success
  end

  test "should update front" do
    patch front_url(@front), params: { front: { index: @front.index } }
    assert_redirected_to front_url(@front)
  end

  test "should destroy front" do
    assert_difference('Front.count', -1) do
      delete front_url(@front)
    end

    assert_redirected_to fronts_url
  end
end
