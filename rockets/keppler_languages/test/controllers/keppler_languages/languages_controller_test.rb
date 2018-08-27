require 'test_helper'

module KepplerLanguages
  class LanguagesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @language = keppler_languages_languages(:one)
    end

    test "should get index" do
      get languages_url
      assert_response :success
    end

    test "should get new" do
      get new_language_url
      assert_response :success
    end

    test "should create language" do
      assert_difference('Language.count') do
        post languages_url, params: { language: { deleted_at: @language.deleted_at, name: @language.name, position: @language.position } }
      end

      assert_redirected_to language_url(Language.last)
    end

    test "should show language" do
      get language_url(@language)
      assert_response :success
    end

    test "should get edit" do
      get edit_language_url(@language)
      assert_response :success
    end

    test "should update language" do
      patch language_url(@language), params: { language: { deleted_at: @language.deleted_at, name: @language.name, position: @language.position } }
      assert_redirected_to language_url(@language)
    end

    test "should destroy language" do
      assert_difference('Language.count', -1) do
        delete language_url(@language)
      end

      assert_redirected_to languages_url
    end
  end
end
