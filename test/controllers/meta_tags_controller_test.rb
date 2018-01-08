require 'test_helper'

class MetaTagsControllerTest < ActionController::TestCase
  setup do
    @meta_tag = meta_tags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meta_tags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meta_tag" do
    assert_difference('MetaTag.count') do
      post :create, meta_tag: { description: @meta_tag.description, meta_tags: @meta_tag.meta_tags, title: @meta_tag.title, url: @meta_tag.url }
    end

    assert_redirected_to meta_tag_path(assigns(:meta_tag))
  end

  test "should show meta_tag" do
    get :show, id: @meta_tag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meta_tag
    assert_response :success
  end

  test "should update meta_tag" do
    patch :update, id: @meta_tag, meta_tag: { description: @meta_tag.description, meta_tags: @meta_tag.meta_tags, title: @meta_tag.title, url: @meta_tag.url }
    assert_redirected_to meta_tag_path(assigns(:meta_tag))
  end

  test "should destroy meta_tag" do
    assert_difference('MetaTag.count', -1) do
      delete :destroy, id: @meta_tag
    end

    assert_redirected_to meta_tags_path
  end
end
