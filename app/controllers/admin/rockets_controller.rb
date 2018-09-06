# frozen_string_literal: true

module Admin
  # MetaTagController
  class RocketsController < AdminController
    before_action :rocket_params, except: %i[rockets]
    before_action :rocket_file_params, only: %i[install]

    # GET /meta_tags
    def rockets
      @rockets = Rocket.names_list
    end

    def create
      Rocket.new_rocket(@rocket_undescore_name)
      redirect_to_rockets_list(@rocket_file_name, @rocket)
    end

    def install
      return unless @rocket && @rocket_file_ext.eql?('rocket')
      install_process(@rocket, @rocket_file_name)
      redirect_to_rockets_list(@rocket_file_name, @rocket)
    end

    def uninstall
      Rocket.uninstall(@rocket) if @rocket
      redirect_to_rockets_list(@rocket_file_name, @rocket)
    end

    def build
      Rocket.build(@rocket)
      redirect_to_rockets_list(@rocket_file_name, @rocket)
    end

    private

    def rocket_params
      @rocket = params[:rocket]
      @rocket_undescore_name = @rocket.parameterize.underscore
      @rocket_class_name = @rocket_undescore_name.classify
    end

    def rocket_file_params
      @rocket_file_name = @rocket.original_filename.split('.').first
      @rocket_file_ext = @rocket.original_filename.split('.').last
    end

    def install_process(rocket_param, rocket_file_name)
      Rocket.save_and_rename(rocket_param)
      Rocket.unzip(rocket_param, rocket_file_name)
      Rocket.install(rocket_file_name)
    end

    # def rocket_msg(rocket_file_name, state)
    #   t(
    #     "keppler.rockets.#{state}",
    #     rocket: rocket_file_name,
    #     action: t("keppler.rockets.#{action_name}")
    #   )
    # end

    def redirect_to_rockets_list(rocket)
      message_action
      redirect_to(
        admin_rockets_path,
        notice: t(
          "keppler.rockets.#{rocket ? 'success' : 'error'}",
          rocket: rocket.camelize,
          action: t("keppler.rockets.#{@action}")
        )
      )
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
