require 'test_helper'

module KepplerCapsules
  class CatalogsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @catalog = keppler_capsules_catalogs(:one)
    end

    test "should get index" do
      get catalogs_url
      assert_response :success
    end

    test "should get new" do
      get new_catalog_url
      assert_response :success
    end

    test "should create catalog" do
      assert_difference('Catalog.count') do
        post catalogs_url, params: { catalog: { deleted_at: @catalog.deleted_at, description: @catalog.description, name: @catalog.name, photo: @catalog.photo, position: @catalog.position } }
      end

      assert_redirected_to catalog_url(Catalog.last)
    end

    test "should show catalog" do
      get catalog_url(@catalog)
      assert_response :success
    end

    test "should get edit" do
      get edit_catalog_url(@catalog)
      assert_response :success
    end

    test "should update catalog" do
      patch catalog_url(@catalog), params: { catalog: { deleted_at: @catalog.deleted_at, description: @catalog.description, name: @catalog.name, photo: @catalog.photo, position: @catalog.position } }
      assert_redirected_to catalog_url(@catalog)
    end

    test "should destroy catalog" do
      assert_difference('Catalog.count', -1) do
        delete catalog_url(@catalog)
      end

      assert_redirected_to catalogs_url
    end
  end
end
