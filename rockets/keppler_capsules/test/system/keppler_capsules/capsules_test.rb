require "application_system_test_case"

module KepplerCapsules
  class CapsulesTest < ApplicationSystemTestCase
    setup do
      @capsule = keppler_capsules_capsules(:one)
    end

    test "visiting the index" do
      visit capsules_url
      assert_selector "h1", text: "Capsules"
    end

    test "creating a Capsule" do
      visit capsules_url
      click_on "New Capsule"

      fill_in "Deleted At", with: @capsule.deleted_at
      fill_in "Name", with: @capsule.name
      fill_in "Position", with: @capsule.position
      click_on "Create Capsule"

      assert_text "Capsule was successfully created"
      click_on "Back"
    end

    test "updating a Capsule" do
      visit capsules_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @capsule.deleted_at
      fill_in "Name", with: @capsule.name
      fill_in "Position", with: @capsule.position
      click_on "Update Capsule"

      assert_text "Capsule was successfully updated"
      click_on "Back"
    end

    test "destroying a Capsule" do
      visit capsules_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Capsule was successfully destroyed"
    end
  end
end
