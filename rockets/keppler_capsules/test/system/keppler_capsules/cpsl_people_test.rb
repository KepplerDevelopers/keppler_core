require "application_system_test_case"

module KepplerCapsules
  class CpslPeopleTest < ApplicationSystemTestCase
    setup do
      @cpsl_person = keppler_capsules_cpsl_people(:one)
    end

    test "visiting the index" do
      visit cpsl_people_url
      assert_selector "h1", text: "Cpsl People"
    end

    test "creating a Cpsl person" do
      visit cpsl_people_url
      click_on "New Cpsl Person"

      fill_in "Deleted At", with: @cpsl_person.deleted_at
      fill_in "Name", with: @cpsl_person.name
      fill_in "Phone", with: @cpsl_person.phone
      fill_in "Position", with: @cpsl_person.position
      click_on "Create Cpsl person"

      assert_text "Cpsl person was successfully created"
      click_on "Back"
    end

    test "updating a Cpsl person" do
      visit cpsl_people_url
      click_on "Edit", match: :first

      fill_in "Deleted At", with: @cpsl_person.deleted_at
      fill_in "Name", with: @cpsl_person.name
      fill_in "Phone", with: @cpsl_person.phone
      fill_in "Position", with: @cpsl_person.position
      click_on "Update Cpsl person"

      assert_text "Cpsl person was successfully updated"
      click_on "Back"
    end

    test "destroying a Cpsl person" do
      visit cpsl_people_url
      page.accept_confirm do
        click_on "Destroy", match: :first
      end

      assert_text "Cpsl person was successfully destroyed"
    end
  end
end
