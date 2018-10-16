# frozen_string_literal: true

module Admin
  # RocketsController
  class RocketsController < AdminController
    skip_before_action :verify_authenticity_token
    before_action :rocket_params, except: %i[rockets install]
    before_action :rocket_file_params, only: %i[install]

    def rockets
      @rockets = Rocket.names_list
    end

    def create
      rocket = Rocket.parse_name(@rocket)
      if (Dir.exist? "#{Rails.root}/rockets/keppler_#{rocket}") || rocket.blank?
        @error = true
        puts "\n\n!!!!! Rocket keppler_#{rocket} is already created !!!!!\n\n"
      else
        Rocket.new_rocket(@rocket_undescore_name)
      end
      redirect_to_rockets_list(@error ? 'error' : @rocket)
    end

    def install
      return unless @rocket && @rocket_file_ext.eql?('rocket')
      install_process(@rocket, @rocket_file_name)
      redirect_to_rockets_list(@rocket)
    end

    def uninstall
      Rocket.uninstall(@rocket) if @rocket
      redirect_to_rockets_list(@rocket)
    end

    def build
      Rocket.build(@rocket)
      redirect_to_rockets_list(@rocket)
    end

    private

    def rocket_params
      @rocket = params[:rocket]
      @rocket_undescore_name = @rocket.parameterize.underscore
      @rocket_class_name = @rocket_undescore_name.classify
    end

    def rocket_file_params
      @rocket = params[:rocket]
      @rocket_file_name = @rocket.original_filename.split('.').first
      @rocket_file_ext = @rocket.original_filename.split('.').last
    end

    def install_process(rocket_param, rocket_file_name)
      Rocket.save_and_rename(rocket_param)
      Rocket.unzip(rocket_param, rocket_file_name)
      Rocket.install(rocket_file_name)
    end

    def redirect_to_rockets_list(rocket)
      message_action
      state = rocket.eql?('error') ? 'error' : 'success'
      flash[state.to_sym] =
        t(
          "keppler.rockets.#{state.eql?('error') ? 'duplicated' : 'success'}",
          rocket: rocket_name(@rocket),
          action: t("keppler.rockets.#{@action}")
        )
      redirect_to admin_rockets_path
    end

    def rocket_name(rocket)
      name =
        if rocket.try(:original_filename).nil?
          Rocket.parse_name(rocket)
        else
          Rocket.parse_name(rocket.original_filename.split('.').first)
        end
      "keppler_#{name}".camelize
    end

    def message_action
      @action =
        case action_name
        when 'build'
          'built'
        when 'create'
          "#{action_name}d"
        else
          "#{action_name}ed"
        end
    end
  end
end
