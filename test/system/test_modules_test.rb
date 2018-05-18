require "application_system_test_case"

class TestModulesTest < ApplicationSystemTestCase
  setup do
    @test_module = test_modules(:one)
  end

  test "visiting the index" do
    visit test_modules_url
    assert_selector "h1", text: "Test Modules"
  end

  test "creating a Test module" do
    visit test_modules_url
    click_on "New Test Module"

    fill_in "Deleted At", with: @test_module.deleted_at
    fill_in "Image", with: @test_module.image
    fill_in "Name", with: @test_module.name
    fill_in "Position", with: @test_module.position
    click_on "Create Test module"

    assert_text "Test module was successfully created"
    click_on "Back"
  end

  test "updating a Test module" do
    visit test_modules_url
    click_on "Edit", match: :first

    fill_in "Deleted At", with: @test_module.deleted_at
    fill_in "Image", with: @test_module.image
    fill_in "Name", with: @test_module.name
    fill_in "Position", with: @test_module.position
    click_on "Update Test module"

    assert_text "Test module was successfully updated"
    click_on "Back"
  end

  test "destroying a Test module" do
    visit test_modules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Test module was successfully destroyed"
  end
end
