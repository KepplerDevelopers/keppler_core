module Admin
  # SettingsController
  class SettingsController < AdminController
    before_action :set_setting, only: [:edit, :update]

    def edit
    end

    def update
      if @setting.update(setting_params)
        redirect_to(
          admin_settings_path(@render), notice: actions_messages(@setting)
        )
      else
        render :edit
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
      @render = params[:config]
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
      params.require(:setting).permit(
        :name, :description, :email, :phone, :mobile, :logo,
        :favicon, :logo_cache, :favicon_cache,
        smtp_setting_attributes: smpt_setting_permit_attributes,
        google_analytics_setting_attributes: ga_setting_permit_attributes,
        social_account_attributes: social_account_permit_attrubutes,
        appearance_attributes: apparence_permit_attributes
      )
    end

    def smpt_setting_permit_attributes
      [:id, :address, :port, :domain_name, :email, :password]
    end

    def ga_setting_permit_attributes
      [:ga_account_id, :ga_tracking_id, :ga_status]
    end

    def social_account_permit_attrubutes
      [
        :facebook, :twitter, :instagram, :google_plus,
        :tripadvisor, :pinterest, :flickr, :behance,
        :dribbble, :tumblr, :github, :linkedin,
        :soundcloud, :youtube, :skype, :vimeo
      ]
    end

    def apparence_permit_attributes
      [
        :id, :theme_name, :image_background,
        :image_background_cache, :remove_image_background
      ]
    end
  end
end
