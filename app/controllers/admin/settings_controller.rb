module Admin
  # SettingsController
  class SettingsController < AdminController
    before_action :set_setting, only: %i[edit update appearance_default]
    before_action :authorization, except: %i[reload appearance_default]

    def edit
      @social_medias = social_account_permit_attributes
      @colors = social_account_colors
    end

    def update
      if @setting.update(setting_params)
        get_apparience_colors([params[:color], params[:darken], params[:accent]]) if theme?
        redirect_to(
          admin_settings_path(@render), notice: actions_messages(@setting)
        )
      else
        render :edit
      end
    end

    def appearance_default
      appearance = Appearance.last
      appearance.remove_image_background!
      appearance.save
      get_apparience_colors(['#f44336'])
      redirect_to(
        admin_settings_path(@render), notice: actions_messages(@setting)
      )
    end

    private

    def theme?
      colors = [params[:color]]
      !colors.include?('') && !colors.include?(nil)
    end

    def get_apparience_colors(values)
      variables_file = File.readlines(style_file)
      indx = 0
      [:color].each_with_index do |attribute, i|
        variables_file.map { |line| indx = variables_file.find_index(line) if line.include?("$keppler-#{attribute}") }
        variables_file[indx] = "$keppler-#{attribute}:#{values[i]};\n"
      end
      variables_file = variables_file.join('')
      File.write(style_file, variables_file)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
      @render = params[:config]
    end

    def authorization
      authorize Setting
    end

    def style_file
      "#{Rails.root}/app/assets/stylesheets/admin/utils/_variables.scss"
    end

    # Only allow a trusted parameter "white list" through.
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
        id theme_name image_background
        image_background_cache remove_image_background
      ]
    end
  end
end
