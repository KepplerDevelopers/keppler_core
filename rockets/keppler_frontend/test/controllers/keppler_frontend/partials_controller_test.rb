require 'test_helper'

module KepplerFrontend
  class PartialsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @partial = keppler_frontend_partials(:one)
    end

    test "should get index" do
      get partials_url
      assert_response :success
    end

    test "should get new" do
      get new_partial_url
      assert_response :success
    end

    test "should create partial" do
      assert_difference('Partial.count') do
        post partials_url, params: { partial: { deleted_at: @partial.deleted_at, name: @partial.name, position: @partial.position } }
      end

      assert_redirected_to partial_url(Partial.last)
    end

    test "should show partial" do
      get partial_url(@partial)
      assert_response :success
    end

    test "should get edit" do
      get edit_partial_url(@partial)
      assert_response :success
    end

    test "should update partial" do
      patch partial_url(@partial), params: { partial: { deleted_at: @partial.deleted_at, name: @partial.name, position: @partial.position } }
      assert_redirected_to partial_url(@partial)
    end

    test "should destroy partial" do
      assert_difference('Partial.count', -1) do
        delete partial_url(@partial)
      end

      assert_redirected_to partials_url
    end
  end
end
