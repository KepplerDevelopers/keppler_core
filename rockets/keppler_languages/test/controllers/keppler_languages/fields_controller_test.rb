require 'test_helper'

module KepplerLanguages
  class FieldsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @field = keppler_languages_fields(:one)
    end

    test "should get index" do
      get fields_url
      assert_response :success
    end

    test "should get new" do
      get new_field_url
      assert_response :success
    end

    test "should create field" do
      assert_difference('Field.count') do
        post fields_url, params: { field: { deleted_at: @field.deleted_at, key: @field.key, position: @field.position, value: @field.value } }
      end

      assert_redirected_to field_url(Field.last)
    end

    test "should show field" do
      get field_url(@field)
      assert_response :success
    end

    test "should get edit" do
      get edit_field_url(@field)
      assert_response :success
    end

    test "should update field" do
      patch field_url(@field), params: { field: { deleted_at: @field.deleted_at, key: @field.key, position: @field.position, value: @field.value } }
      assert_redirected_to field_url(@field)
    end

    test "should destroy field" do
      assert_difference('Field.count', -1) do
        delete field_url(@field)
      end

      assert_redirected_to fields_url
    end
  end
end
