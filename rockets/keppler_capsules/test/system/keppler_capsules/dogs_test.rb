require "application_system_test_case"

module KepplerCapsules
  class DogsTest < ApplicationSystemTestCase
    setup do
      @dog = keppler_capsules_dogs(:one)
    end

    test "visiting the index" do
      visit dogs_url
      assert_selector "h1", text: "Dogs"
    end

    test "creating a Dog" do
      visit dogs_url
      click_on "New Dog"

      fill_in "Deleted At", with: @dog.deleted_at
      fill_in "Name", with: @dog.name
      fill_in "Position", with: @dog.position
      click_on "Create Dog"

      assert_text "Dog was successfully created"
      click_on "Back"
    end

    test "updating a Dog" do
      visit dogs_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @dog.deleted_at
      fill_in "Name", with: @dog.name
      fill_in "Position", with: @dog.position
      click_on "Update Dog"

      assert_text "Dog was successfully updated"
      click_on "Back"
    end

    test "destroying a Dog" do
      visit dogs_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Dog was successfully destroyed"
    end
  end
end
