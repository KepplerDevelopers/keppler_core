require 'test_helper'

module KepplerWorld
  class PlanetsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @planet = keppler_world_planets(:one)
    end

    test "should get index" do
      get planets_url
      assert_response :success
    end

    test "should get new" do
      get new_planet_url
      assert_response :success
    end

    test "should create planet" do
      assert_difference('Planet.count') do
        post planets_url, params: { planet: { age: @planet.age, avatar: @planet.avatar, deleted_at: @planet.deleted_at, description: @planet.description, fecha: @planet.fecha, images: @planet.images, money: @planet.money, name: @planet.name, position: @planet.position, tiempo: @planet.tiempo } }
      end

      assert_redirected_to planet_url(Planet.last)
    end

    test "should show planet" do
      get planet_url(@planet)
      assert_response :success
    end

    test "should get edit" do
      get edit_planet_url(@planet)
      assert_response :success
    end

    test "should update planet" do
      patch planet_url(@planet), params: { planet: { age: @planet.age, avatar: @planet.avatar, deleted_at: @planet.deleted_at, description: @planet.description, fecha: @planet.fecha, images: @planet.images, money: @planet.money, name: @planet.name, position: @planet.position, tiempo: @planet.tiempo } }
      assert_redirected_to planet_url(@planet)
    end

    test "should destroy planet" do
      assert_difference('Planet.count', -1) do
        delete planet_url(@planet)
      end

      assert_redirected_to planets_url
    end
  end
end
