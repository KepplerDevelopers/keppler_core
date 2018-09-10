require 'test_helper'

module KepplerFrontend
  class CallbackFunctionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @callback_function = keppler_frontend_callback_functions(:one)
    end

    test "should get index" do
      get callback_functions_url
      assert_response :success
    end

    test "should get new" do
      get new_callback_function_url
      assert_response :success
    end

    test "should create callback_function" do
      assert_difference('CallbackFunction.count') do
        post callback_functions_url, params: { callback_function: { deleted_at: @callback_function.deleted_at, description: @callback_function.description, name: @callback_function.name, position: @callback_function.position } }
      end

      assert_redirected_to callback_function_url(CallbackFunction.last)
    end

    test "should show callback_function" do
      get callback_function_url(@callback_function)
      assert_response :success
    end

    test "should get edit" do
      get edit_callback_function_url(@callback_function)
      assert_response :success
    end

    test "should update callback_function" do
      patch callback_function_url(@callback_function), params: { callback_function: { deleted_at: @callback_function.deleted_at, description: @callback_function.description, name: @callback_function.name, position: @callback_function.position } }
      assert_redirected_to callback_function_url(@callback_function)
    end

    test "should destroy callback_function" do
      assert_difference('CallbackFunction.count', -1) do
        delete callback_function_url(@callback_function)
      end

      assert_redirected_to callback_functions_url
    end
  end
end
