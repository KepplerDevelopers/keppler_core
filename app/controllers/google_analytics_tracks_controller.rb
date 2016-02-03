#Generado con Keppler.
class GoogleAnalyticsTracksController < ApplicationController  
  before_filter :authenticate_user!
  layout 'admin/application'
  load_and_authorize_resource
  before_action :set_google_analytics_track, only: [:show, :edit, :update, :destroy]
  before_action :show_history, only: [:index]

  # GET /google_analytics_tracks
  def index
    google_analytics_tracks = GoogleAnalyticsTrack.searching(@query).all
    @objects, @total = google_analytics_tracks.page(@current_page), google_analytics_tracks.size
    redirect_to google_analytics_tracks_path(page: @current_page.to_i.pred, search: @query) if !@objects.first_page? and @objects.size.zero?
  end

  # GET /google_analytics_tracks/1
  def show
  end

  # GET /google_analytics_tracks/new
  def new
    @google_analytics_track = GoogleAnalyticsTrack.new
  end

  # GET /google_analytics_tracks/1/edit
  def edit
  end

  # POST /google_analytics_tracks
  def create
    @google_analytics_track = GoogleAnalyticsTrack.new(google_analytics_track_params)

    if @google_analytics_track.save
      redirect(@google_analytics_track, params)
    else
      render :new
    end
  end

  # PATCH/PUT /google_analytics_tracks/1
  def update
    if @google_analytics_track.update(google_analytics_track_params)
      redirect(@google_analytics_track, params)
    else
      render :edit
    end
  end

  # DELETE /google_analytics_tracks/1
  def destroy
    @google_analytics_track.destroy
    redirect_to google_analytics_tracks_url, notice: t('keppler.messages.successfully.deleted', model: t("keppler.models.singularize.google_analytics_track").humanize) 
  end

  def destroy_multiple
    GoogleAnalyticsTrack.destroy redefine_ids(params[:multiple_ids])
    redirect_to google_analytics_tracks_path(page: @current_page, search: @query), notice: t('keppler.messages.successfully.removed', model: t("keppler.models.singularize.google_analytics_track").humanize) 
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_google_analytics_track
    @google_analytics_track = GoogleAnalyticsTrack.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def google_analytics_track_params
    params.require(:google_analytics_track).permit(:name, :tracking_id, :url)
  end

  def show_history
    if current_user.has_role? :admin
      @activities = PublicActivity::Activity.where(trackable_type: 'GoogleAnalyticsTrack').order("created_at desc").limit(50)
    else
      @activities = PublicActivity::Activity.where("trackable_type = 'GoogleAnalyticsTrack' and owner_id=#{current_user.id}").order("created_at desc").limit(50)
    end
  end

end
