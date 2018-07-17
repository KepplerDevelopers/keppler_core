require 'test_helper'

module KepplerFrontend
  class ViewsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @view = keppler_frontend_views(:one)
    end

    test "should get index" do
      get views_url
      assert_response :success
    end

    test "should get new" do
      get new_view_url
      assert_response :success
    end

    test "should create view" do
      assert_difference('View.count') do
        post views_url, params: { view: { active: @view.active, deleted_at: @view.deleted_at, format_result: @view.format_result, method: @view.method, name: @view.name, position: @view.position, root_path: @view.root_path, url: @view.url } }
      end

      assert_redirected_to view_url(View.last)
    end

    test "should show view" do
      get view_url(@view)
      assert_response :success
    end

    test "should get edit" do
      get edit_view_url(@view)
      assert_response :success
    end

    test "should update view" do
      patch view_url(@view), params: { view: { active: @view.active, deleted_at: @view.deleted_at, format_result: @view.format_result, method: @view.method, name: @view.name, position: @view.position, root_path: @view.root_path, url: @view.url } }
      assert_redirected_to view_url(@view)
    end

    test "should destroy view" do
      assert_difference('View.count', -1) do
        delete view_url(@view)
      end

      assert_redirected_to views_url
    end
  end
end
