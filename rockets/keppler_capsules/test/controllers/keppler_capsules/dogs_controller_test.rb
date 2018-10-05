require 'test_helper'

module KepplerCapsules
  class DogsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @dog = keppler_capsules_dogs(:one)
    end

    test "should get index" do
      get dogs_url
      assert_response :success
    end

    test "should get new" do
      get new_dog_url
      assert_response :success
    end

    test "should create dog" do
      assert_difference('Dog.count') do
        post dogs_url, params: { dog: { deleted_at: @dog.deleted_at, name: @dog.name, position: @dog.position } }
      end

      assert_redirected_to dog_url(Dog.last)
    end

    test "should show dog" do
      get dog_url(@dog)
      assert_response :success
    end

    test "should get edit" do
      get edit_dog_url(@dog)
      assert_response :success
    end

    test "should update dog" do
      patch dog_url(@dog), params: { dog: { deleted_at: @dog.deleted_at, name: @dog.name, position: @dog.position } }
      assert_redirected_to dog_url(@dog)
    end

    test "should destroy dog" do
      assert_difference('Dog.count', -1) do
        delete dog_url(@dog)
      end

      assert_redirected_to dogs_url
    end
  end
end
