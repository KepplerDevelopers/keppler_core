require "application_system_test_case"

module KepplerFrontend
  class CallbackFunctionsTest < ApplicationSystemTestCase
    setup do
      @callback_function = keppler_frontend_callback_functions(:one)
    end

    test "visiting the index" do
      visit callback_functions_url
      assert_selector "h1", text: "Callback Functions"
    end

    test "creating a Callback function" do
      visit callback_functions_url
      click_on "New Callback Function"

      fill_in "Deleted At", with: @callback_function.deleted_at
      fill_in "Description", with: @callback_function.description
      fill_in "Name", with: @callback_function.name
      fill_in "Position", with: @callback_function.position
      click_on "Create Callback function"

      assert_text "Callback function was successfully created"
      click_on "Back"
    end

    test "updating a Callback function" do
      visit callback_functions_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @callback_function.deleted_at
      fill_in "Description", with: @callback_function.description
      fill_in "Name", with: @callback_function.name
      fill_in "Position", with: @callback_function.position
      click_on "Update Callback function"

      assert_text "Callback function was successfully updated"
      click_on "Back"
    end

    test "destroying a Callback function" do
      visit callback_functions_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Callback function was successfully destroyed"
    end
  end
end
