require "application_system_test_case"

module KepplerStarklord
  class ElliotsTest < ApplicationSystemTestCase
    setup do
      @elliot = keppler_starklord_elliots(:one)
    end

    test "visiting the index" do
      visit elliots_url
      assert_selector "h1", text: "Elliots"
    end

    test "creating a Elliot" do
      visit elliots_url
      click_on "New Elliot"

      fill_in "Avatar", with: @elliot.avatar
      fill_in "Birthdate", with: @elliot.birthdate
      fill_in "Deleted At", with: @elliot.deleted_at
      fill_in "Name", with: @elliot.name
      fill_in "Photos", with: @elliot.photos
      fill_in "Position", with: @elliot.position
      fill_in "User", with: @elliot.user_id
      click_on "Create Elliot"

      assert_text "Elliot was successfully created"
      click_on "Back"
    end

    test "updating a Elliot" do
      visit elliots_url
      click_on "Edit", match: :first

      fill_in "Avatar", with: @elliot.avatar
      fill_in "Birthdate", with: @elliot.birthdate
      fill_in "Deleted At", with: @elliot.deleted_at
      fill_in "Name", with: @elliot.name
      fill_in "Photos", with: @elliot.photos
      fill_in "Position", with: @elliot.position
      fill_in "User", with: @elliot.user_id
      click_on "Update Elliot"

      assert_text "Elliot was successfully updated"
      click_on "Back"
    end

    test "destroying a Elliot" do
      visit elliots_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Elliot was successfully destroyed"
    end
  end
end
