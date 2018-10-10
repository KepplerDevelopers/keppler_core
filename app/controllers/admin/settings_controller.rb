# frozen_string_literal: true

module Admin
  # SettingsController
  class SettingsController < AdminController
    include Settings

    before_action :set_setting, only: %i[edit update appearance_default]
    before_action :authorization, except: %i[reload appearance_default]
    after_action :update_settings_yml, only: %i[create update destroy clone]

    def edit
      @social_medias = social_account_permit_attributes
      @colors = social_account_colors
      @languages = %w[en es]
    end

    def update
      upload_p12(params)

      if @setting.update(setting_params)
        update_ga_status(params)
        appearance_service.get_color(parsed_color)
        redirect_to(
          admin_settings_path(@render), notice: actions_messages(@setting)
        )
      else
        render :edit
      end
    end

    def update_ga_status(params)
      return unless params[:setting][:google_analytics_setting]
      status = params[:setting][:google_analytics_setting][:ga_status]
      return if status.nil?
      @setting.google_analytics_setting.update(ga_status: status)
    end

    def change_locale
      Appearance.first.update(language: params[:locale])
      redirect_back fallback_location: admin_root_path
    end

    def appearance_default
      appearance_service.set_default
      redirect_to(
        admin_settings_path(@render), notice: actions_messages(@setting)
      )
    end

    def upload_p12(params)
      return unless params['google_analytics_setting_attributes']
      return unless params['google_analytics_setting_attributes']['p12']
      file = params['google_analytics_setting_attributes']['p12']
      name = file.original_filename
      path = File.join('config', 'gaAuth', name)
      File.open(path, 'wb') { |f| f.write(file.read) }
    end

    private

    def appearance_service
      Admin::AppearanceService.new
    end

    def parsed_color
      if params[:color].include?('#') || params[:color].include?('rgb')
        params[:color]
      else
        "##{params[:color]}"
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
      @render = params[:config]
    end

    def authorization
      authorize Setting
    end

    # Only allow a trusted parameter 'white list' through.
    def setting_params
      params.require(:setting).permit(
        :name, :description, :email, :phone, :mobile, :logo,
        :favicon, :logo_cache, :favicon_cache,
        smtp_setting_attributes: smpt_setting_permit_attributes,
        google_analytics_setting_attributes: ga_setting_permit_attributes,
        social_account_attributes: social_account_permit_attributes,
        appearance_attributes: apparence_permit_attributes
      )
    end

    def smpt_setting_permit_attributes
      %i[id address port domain_name email password]
    end

    def ga_setting_permit_attributes
      %i[ga_account_id ga_tracking_id ga_status]
    end

    def social_account_permit_attributes
      %i[
        facebook twitter instagram google_plus
        tripadvisor pinterest flickr behance
        dribbble tumblr github linkedin
        soundcloud youtube skype vimeo
      ]
    end

    def social_account_colors
      %w[
        #3b5998 #1da1f2 #e1306c #dd4b39
        #00af87 #bd081c #ff0084 #1769ff
        #ff8833 #35465c #333333 #0077b5
        #ff8800 #ff0000 #00aff0 #162221
      ]
    end

    def apparence_permit_attributes
      %i[
        id theme_name image_background language time_zone
        image_background_cache remove_image_background
      ]
    end
  end
end
