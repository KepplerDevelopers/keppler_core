# frozen_string_literal: true

module Admin
  # MetaTagController
  class RocketsController < AdminController
    before_action :rocket_name_params, only: %i[create uninstall build]
    before_action :rocket_file_params, only: %i[install]

    # GET /meta_tags
    def rockets
      @rockets = Rocket.names_list
    end

    def create
      Rocket.new_rocket(@rocket_undescore_name)
      redirect_to admin_rockets_path
    end

    def install
      if params[:rocket] && @rocket_file_ext.eql?('rocket')
        Rocket.save_and_rename(params[:rocket])
        Rocket.unzip(params[:rocket], @rocket_file_name)
        Rocket.install(@rocket_file_name)
        flash[:notice] = "#{@rocket_file_name} has been installed"
      else
        flash[:error] = "#{@rocket_file_name} has not been installed"
      end
      redirect_to admin_rockets_path
    end

    def uninstall
      if params[:rocket]
        Rocket.uninstall(params[:rocket])
        redirect_to admin_rockets_path
      else
        render :rockets, notice: 'Rocket don\'t found! :('
      end
    end

    def build
      if params[:rocket]
        rocket_built = Rocket.build(params[:rocket])
        flash[:built] = "Rocket has #{'not' unless rocket_built} been updated"
        redirect_to admin_rockets_path
      else
        render :rockets, notice: 'Rocket don\'t found! :('
      end
    end

    private

    def rocket_name_params
      @rocket_undescore_name = params[:rocket].parameterize.underscore
      @rocket_class_name = @rocket_undescore_name.classify
    end

    def rocket_file_params
      @rocket_file_name = params[:rocket].original_filename.split('.').first
      @rocket_file_ext = params[:rocket].original_filename.split('.').last
    end
  end
end
