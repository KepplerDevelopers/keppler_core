require 'test_helper'

module KepplerStarklord
  class ElliotsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @elliot = keppler_starklord_elliots(:one)
    end

    test "should get index" do
      get elliots_url
      assert_response :success
    end

    test "should get new" do
      get new_elliot_url
      assert_response :success
    end

    test "should create elliot" do
      assert_difference('Elliot.count') do
        post elliots_url, params: { elliot: { avatar: @elliot.avatar, birthdate: @elliot.birthdate, deleted_at: @elliot.deleted_at, name: @elliot.name, photos: @elliot.photos, position: @elliot.position, user_id: @elliot.user_id } }
      end

      assert_redirected_to elliot_url(Elliot.last)
    end

    test "should show elliot" do
      get elliot_url(@elliot)
      assert_response :success
    end

    test "should get edit" do
      get edit_elliot_url(@elliot)
      assert_response :success
    end

    test "should update elliot" do
      patch elliot_url(@elliot), params: { elliot: { avatar: @elliot.avatar, birthdate: @elliot.birthdate, deleted_at: @elliot.deleted_at, name: @elliot.name, photos: @elliot.photos, position: @elliot.position, user_id: @elliot.user_id } }
      assert_redirected_to elliot_url(@elliot)
    end

    test "should destroy elliot" do
      assert_difference('Elliot.count', -1) do
        delete elliot_url(@elliot)
      end

      assert_redirected_to elliots_url
    end
  end
end
