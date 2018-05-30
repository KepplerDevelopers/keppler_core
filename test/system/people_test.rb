require "application_system_test_case"

class PeopleTest < ApplicationSystemTestCase
  setup do
    @person = people(:one)
  end

  test "visiting the index" do
    visit people_url
    assert_selector "h1", text: "People"
  end

  test "creating a Person" do
    visit people_url
    click_on "New Person"

    fill_in "Birth", with: @person.birth
    fill_in "Deleted At", with: @person.deleted_at
    fill_in "Description", with: @person.description
    fill_in "Hour", with: @person.hour
    fill_in "Name", with: @person.name
    fill_in "Photo", with: @person.photo
    fill_in "Position", with: @person.position
    fill_in "Public", with: @person.public
    fill_in "User", with: @person.user_id
    click_on "Create Person"

    assert_text "Person was successfully created"
    click_on "Back"
  end

  test "updating a Person" do
    visit people_url
    click_on "Edit", match: :first

    fill_in "Birth", with: @person.birth
    fill_in "Deleted At", with: @person.deleted_at
    fill_in "Description", with: @person.description
    fill_in "Hour", with: @person.hour
    fill_in "Name", with: @person.name
    fill_in "Photo", with: @person.photo
    fill_in "Position", with: @person.position
    fill_in "Public", with: @person.public
    fill_in "User", with: @person.user_id
    click_on "Update Person"

    assert_text "Person was successfully updated"
    click_on "Back"
  end

  test "destroying a Person" do
    visit people_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Person was successfully destroyed"
  end
end
