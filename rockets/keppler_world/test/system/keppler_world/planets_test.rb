require "application_system_test_case"

module KepplerWorld
  class PlanetsTest < ApplicationSystemTestCase
    setup do
      @planet = keppler_world_planets(:one)
    end

    test "visiting the index" do
      visit planets_url
      assert_selector "h1", text: "Planets"
    end

    test "creating a Planet" do
      visit planets_url
      click_on "New Planet"

      fill_in "Age", with: @planet.age
      fill_in "Avatar", with: @planet.avatar
      fill_in "Deleted At", with: @planet.deleted_at
      fill_in "Description", with: @planet.description
      fill_in "Fecha", with: @planet.fecha
      fill_in "Images", with: @planet.images
      fill_in "Money", with: @planet.money
      fill_in "Name", with: @planet.name
      fill_in "Position", with: @planet.position
      fill_in "Tiempo", with: @planet.tiempo
      click_on "Create Planet"

      assert_text "Planet was successfully created"
      click_on "Back"
    end

    test "updating a Planet" do
      visit planets_url
      click_on "Edit", match: :first

      fill_in "Age", with: @planet.age
      fill_in "Avatar", with: @planet.avatar
      fill_in "Deleted At", with: @planet.deleted_at
      fill_in "Description", with: @planet.description
      fill_in "Fecha", with: @planet.fecha
      fill_in "Images", with: @planet.images
      fill_in "Money", with: @planet.money
      fill_in "Name", with: @planet.name
      fill_in "Position", with: @planet.position
      fill_in "Tiempo", with: @planet.tiempo
      click_on "Update Planet"

      assert_text "Planet was successfully updated"
      click_on "Back"
    end

    test "destroying a Planet" do
      visit planets_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Planet was successfully destroyed"
    end
  end
end
