module Admin
  # SettingsController
  class SettingsController < AdminController
    before_action :set_setting, only: [:edit, :update, :appearance_default]
    before_action :set_apparience_colors

    def edit
    end

    def update
      if @setting.update(setting_params)
        get_apparience_colors([params[:color], params[:darken], params[:accent]])
        redirect_to(
          admin_settings_path(@render), notice: actions_messages(@setting)
        )
      else
        render :edit
      end
    end

    def appearance_default
      get_apparience_colors(["#f44336", "#d32f2f", "#009688"])
      redirect_to(
        admin_settings_path(@render), notice: actions_messages(@setting)
      )
    end

    private

    def set_apparience_colors
      variables_file = File.readlines(style_file)
      @color, @darken, @accent = ""
      variables_file.each { |line| @color = line[15..21] if line.include?('$keppler-color') }
      variables_file.each { |line| @darken = line[16..22] if line.include?('$keppler-darken') }
      variables_file.each { |line| @accent = line[16..22] if line.include?('$keppler-accent') }
    end

    def get_apparience_colors(values)
      variables_file = File.readlines(style_file)
      indx = 0
      [:color, :darken, :accent].each_with_index do |attribute, i|
        variables_file.map { |line| indx = variables_file.find_index(line) if line.include?("$keppler-#{attribute}") }
        variables_file[indx] = "$keppler-#{attribute}:#{values[i]};\n"
      end
      variables_file = variables_file.join("")
      File.write(style_file, variables_file)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
      @render = params[:config]
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
