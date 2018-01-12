require 'test_helper'

class GoogleAnalyticsTracksControllerTest < ActionController::TestCase
  setup do
    @google_analytics_track = google_analytics_tracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:google_analytics_tracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create google_analytics_track" do
    assert_difference('GoogleAnalyticsTrack.count') do
      post :create, google_analytics_track: { name: @google_analytics_track.name, tracking_id: @google_analytics_track.tracking_id, url: @google_analytics_track.url }
    end

    assert_redirected_to google_analytics_track_path(assigns(:google_analytics_track))
  end

  test "should show google_analytics_track" do
    get :show, id: @google_analytics_track
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @google_analytics_track
    assert_response :success
  end

  test "should update google_analytics_track" do
    patch :update, id: @google_analytics_track, google_analytics_track: { name: @google_analytics_track.name, tracking_id: @google_analytics_track.tracking_id, url: @google_analytics_track.url }
    assert_redirected_to google_analytics_track_path(assigns(:google_analytics_track))
  end

  test "should destroy google_analytics_track" do
    assert_difference('GoogleAnalyticsTrack.count', -1) do
      delete :destroy, id: @google_analytics_track
    end

    assert_redirected_to google_analytics_tracks_path
  end
end
