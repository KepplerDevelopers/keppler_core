require 'test_helper'

class GalleriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gallery = galleries(:one)
  end

  test "should get index" do
    get galleries_url
    assert_response :success
  end

  test "should get new" do
    get new_gallery_url
    assert_response :success
  end

  test "should create gallery" do
    assert_difference('Gallery.count') do
      post galleries_url, params: { gallery: { audio: @gallery.audio, avatar: @gallery.avatar, deleted_at: @gallery.deleted_at, files: @gallery.files, images: @gallery.images, pdf: @gallery.pdf, position: @gallery.position, txt: @gallery.txt, video: @gallery.video } }
    end

    assert_redirected_to gallery_url(Gallery.last)
  end

  test "should show gallery" do
    get gallery_url(@gallery)
    assert_response :success
  end

  test "should get edit" do
    get edit_gallery_url(@gallery)
    assert_response :success
  end

  test "should update gallery" do
    patch gallery_url(@gallery), params: { gallery: { audio: @gallery.audio, avatar: @gallery.avatar, deleted_at: @gallery.deleted_at, files: @gallery.files, images: @gallery.images, pdf: @gallery.pdf, position: @gallery.position, txt: @gallery.txt, video: @gallery.video } }
    assert_redirected_to gallery_url(@gallery)
  end

  test "should destroy gallery" do
    assert_difference('Gallery.count', -1) do
      delete gallery_url(@gallery)
    end

    assert_redirected_to galleries_url
  end
end
