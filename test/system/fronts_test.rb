require "application_system_test_case"

class FrontsTest < ApplicationSystemTestCase
  setup do
    @front = fronts(:one)
  end

  test "visiting the index" do
    visit fronts_url
    assert_selector "h1", text: "Fronts"
  end

  test "creating a Front" do
    visit fronts_url
    click_on "New Front"

    fill_in "Index", with: @front.index
    click_on "Create Front"

    assert_text "Front was successfully created"
    click_on "Back"
  end

  test "updating a Front" do
    visit fronts_url
    click_on "Edit", match: :first

    fill_in "Index", with: @front.index
    click_on "Update Front"

    assert_text "Front was successfully updated"
    click_on "Back"
  end

  test "destroying a Front" do
    visit fronts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Front was successfully destroyed"
  end
end
