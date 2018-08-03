require "application_system_test_case"

module KepplerCapsules
  class CatalogsTest < ApplicationSystemTestCase
    setup do
      @catalog = keppler_capsules_catalogs(:one)
    end

    test "visiting the index" do
      visit catalogs_url
      assert_selector "h1", text: "Catalogs"
    end

    test "creating a Catalog" do
      visit catalogs_url
      click_on "New Catalog"

      fill_in "Deleted At", with: @catalog.deleted_at
      fill_in "Description", with: @catalog.description
      fill_in "Name", with: @catalog.name
      fill_in "Photo", with: @catalog.photo
      fill_in "Position", with: @catalog.position
      click_on "Create Catalog"

      assert_text "Catalog was successfully created"
      click_on "Back"
    end

    test "updating a Catalog" do
      visit catalogs_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @catalog.deleted_at
      fill_in "Description", with: @catalog.description
      fill_in "Name", with: @catalog.name
      fill_in "Photo", with: @catalog.photo
      fill_in "Position", with: @catalog.position
      click_on "Update Catalog"

      assert_text "Catalog was successfully updated"
      click_on "Back"
    end

    test "destroying a Catalog" do
      visit catalogs_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Catalog was successfully destroyed"
    end
  end
end
