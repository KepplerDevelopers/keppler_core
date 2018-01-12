module Admin
  # GoogleAnalyticsTracksController
  class GoogleAnalyticsTracksController < AdminController
    before_action :set_ga_track, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /google_analytics_tracks
    def index
      @q = GoogleAnalyticsTrack.ransack(params[:q])
      google_analytics_tracks = @q.result(distinct: true)
      @objects = google_analytics_tracks.page(@current_page)
      @total = google_analytics_tracks.size

      if !@objects.first_page? && @objects.size.zero?
        redirect_to(
          google_analytics_tracks_path(
            page: @current_page.to_i.pred,
            search: @query)
        )
      end
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
      @google_analytics_track =
        GoogleAnalyticsTrack.new(google_analytics_track_params)

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

      redirect_to(
        admin_google_analytics_tracks_path,
        notice: actions_messages(@google_analytics_track)
      )
    end

    def destroy_multiple
      GoogleAnalyticsTrack.destroy redefine_ids(params[:multiple_ids])

      redirect_to(
        admin_google_analytics_tracks_path(page: @current_page, search: @query),
        notice: actions_messages(GoogleAnalyticsTrack.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_ga_track
      @google_analytics_track = GoogleAnalyticsTrack.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def google_analytics_track_params
      params.require(:google_analytics_track).permit(:name, :tracking_id, :url)
    end

    def show_history
      get_history(GoogleAnalyticsTrack)
    end
  end
end
