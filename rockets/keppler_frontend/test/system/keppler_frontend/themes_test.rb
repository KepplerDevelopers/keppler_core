require "application_system_test_case"

module KepplerFrontend
  class ThemesTest < ApplicationSystemTestCase
    setup do
      @theme = keppler_frontend_themes(:one)
    end

    test "visiting the index" do
      visit themes_url
      assert_selector "h1", text: "Themes"
    end

    test "creating a Theme" do
      visit themes_url
      click_on "New Theme"

      fill_in "Active", with: @theme.active
      fill_in "Deleted At", with: @theme.deleted_at
      fill_in "Name", with: @theme.name
      fill_in "Position", with: @theme.position
      click_on "Create Theme"

      assert_text "Theme was successfully created"
      click_on "Back"
    end

    test "updating a Theme" do
      visit themes_url
      click_on "Edit", match: :first

      fill_in "Active", with: @theme.active
      fill_in "Deleted At", with: @theme.deleted_at
      fill_in "Name", with: @theme.name
      fill_in "Position", with: @theme.position
      click_on "Update Theme"

      assert_text "Theme was successfully updated"
      click_on "Back"
    end

    test "destroying a Theme" do
      visit themes_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Theme was successfully destroyed"
    end
  end
end
