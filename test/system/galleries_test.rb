require "application_system_test_case"

class GalleriesTest < ApplicationSystemTestCase
  setup do
    @gallery = galleries(:one)
  end

  test "visiting the index" do
    visit galleries_url
    assert_selector "h1", text: "Galleries"
  end

  test "creating a Gallery" do
    visit galleries_url
    click_on "New Gallery"

    fill_in "Audio", with: @gallery.audio
    fill_in "Avatar", with: @gallery.avatar
    fill_in "Deleted At", with: @gallery.deleted_at
    fill_in "Files", with: @gallery.files
    fill_in "Images", with: @gallery.images
    fill_in "Pdf", with: @gallery.pdf
    fill_in "Position", with: @gallery.position
    fill_in "Txt", with: @gallery.txt
    fill_in "Video", with: @gallery.video
    click_on "Create Gallery"

    assert_text "Gallery was successfully created"
    click_on "Back"
  end

  test "updating a Gallery" do
    visit galleries_url
    click_on "Edit", match: :first

    fill_in "Audio", with: @gallery.audio
    fill_in "Avatar", with: @gallery.avatar
    fill_in "Deleted At", with: @gallery.deleted_at
    fill_in "Files", with: @gallery.files
    fill_in "Images", with: @gallery.images
    fill_in "Pdf", with: @gallery.pdf
    fill_in "Position", with: @gallery.position
    fill_in "Txt", with: @gallery.txt
    fill_in "Video", with: @gallery.video
    click_on "Update Gallery"

    assert_text "Gallery was successfully updated"
    click_on "Back"
  end

  test "destroying a Gallery" do
    visit galleries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Gallery was successfully destroyed"
  end
end
