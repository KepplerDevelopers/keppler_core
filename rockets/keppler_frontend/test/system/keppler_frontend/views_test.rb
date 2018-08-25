require "application_system_test_case"

module KepplerFrontend
  class ViewsTest < ApplicationSystemTestCase
    setup do
      @view = keppler_frontend_views(:one)
    end

    test "visiting the index" do
      visit views_url
      assert_selector "h1", text: "Views"
    end

    test "creating a View" do
      visit views_url
      click_on "New View"

      fill_in "Active", with: @view.active
      fill_in "Deleted At", with: @view.deleted_at
      fill_in "Format Result", with: @view.format_result
      fill_in "Method", with: @view.method
      fill_in "Name", with: @view.name
      fill_in "Position", with: @view.position
      fill_in "Root Path", with: @view.root_path
      fill_in "Url", with: @view.url
      click_on "Create View"

      assert_text "View was successfully created"
      click_on "Back"
    end

    test "updating a View" do
      visit views_url
      click_on "Edit", match: :first

      fill_in "Active", with: @view.active
      fill_in "Deleted At", with: @view.deleted_at
      fill_in "Format Result", with: @view.format_result
      fill_in "Method", with: @view.method
      fill_in "Name", with: @view.name
      fill_in "Position", with: @view.position
      fill_in "Root Path", with: @view.root_path
      fill_in "Url", with: @view.url
      click_on "Update View"

      assert_text "View was successfully updated"
      click_on "Back"
    end

    test "destroying a View" do
      visit views_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "View was successfully destroyed"
    end
  end
end
