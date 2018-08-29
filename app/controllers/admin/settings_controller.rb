# frozen_string_literal: true

module Admin
  # SettingsController
  class SettingsController < AdminController
    before_action :set_setting, only: %i[edit update appearance_default]
    before_action :authorization, except: %i[reload appearance_default]
    after_action :update_settings_yml, only: [:create, :update, :destroy, :destroy_multiple, :clone]

    def edit
      @social_medias = social_account_permit_attributes
      @colors = social_account_colors
    end

    def update
      if @setting.update(setting_params)
        appearance_service.get_color(params[:color])
        redirect_to(
          admin_settings_path(@render), notice: actions_messages(@setting)
        )
      else
        render :edit
      end
    end

    def appearance_default
      appearance_service.set_default
      redirect_to(
        admin_settings_path(@render), notice: actions_messages(@setting)
      )
    end

    private

    def basic_information_fields
      setting = Setting.first

      basic_information = [
        Hash['name', setting.name],
        Hash['description', setting.description],
        Hash['email', setting.email],
        Hash['phone', setting.phone],
        Hash['mobile', setting.mobile]
      ]
    end

    def smtp_fields
      smtp = Setting.first.smtp_setting

      smtp_settings = [
        Hash['address', smtp.address],
        Hash['port', smtp.port],
        Hash['domain_name', smtp.domain_name],
        Hash['smtp_email', smtp.email],
        Hash['password', smtp.password]
      ]
    end

    def google_analytics_fields
      google = Setting.first.google_analytics_setting

      google_analytics_setting = [
        Hash['ga_account_id', google.ga_account_id],
        Hash['ga_tracking_id', google.ga_tracking_id],
        Hash['ga_status', google.ga_status]
      ]
    end

    def social_accounts_fields
      social = Setting.first.social_account

      social_accounts = [
        Hash['facebook', social.facebook],
        Hash['twitter', social.twitter],
        Hash['instagram', social.instagram],
        Hash['google_plus', social.google_plus],
        Hash['tripadvisor', social.tripadvisor],
        Hash['pinterest', social.pinterest],
        Hash['flickr', social.flickr],
        Hash['behance', social.behance],
        Hash['dribbble', social.dribbble],
        Hash['tumblr', social.tumblr],
        Hash['github', social.github],
        Hash['linkedin', social.linkedin],
        Hash['soundcloud', social.soundcloud],
        Hash['youtube', social.youtube],
        Hash['skype', social.skype],
        Hash['vimeo', social.vimeo]
      ]
    end

    def appearance_fields
      fields = Setting.first.appearance

      appearance = [
        Hash['theme_name', fields.theme_name]
      ]
    end

    def update_settings_yml
      file =  File.join("#{Rails.root}/config/settings.yml")

      data = basic_information_fields.push(
        smtp_fields,
        google_analytics_fields,
        social_accounts_fields,
        appearance_fields
      ).flatten.as_json.to_yaml

      File.write(file, data)
      delete_underscores(file)
    end

    def delete_underscores(file)
      yml = File.readlines(file)
      yml.each_with_index do |line, index|
        if yml[index].include?('-') && yml[index] != ("---\n")
          yml[index] = yml[index].gsub('-', ' ')
        end
      end

      yml = yml.join('')
      File.write(file, yml)
    end

    def appearance_service
      Admin::AppearanceService.new
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.first
      @render = params[:config]
    end

    def authorization
      authorize Setting
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
