# frozen_string_literal: true

module Admin
  # MetaTagController
  class RocketsController < AdminController
    before_action :rocket_params, only: %i[install_rocket]

    # GET /meta_tags
    def rockets
      @rockets = Rocket.names_list
    end

    def install_rocket
      if @rocket_file && @rocket_ext.eql?('rocket')
        Rocket.save_and_rename(@rocket_file)
        Rocket.unzip(@rocket_file, @rocket_name)
        Rocket.install(@rocket_name)
        flash[:notice] = "#{@rocket_name} has been installed"
      else
        flash[:error] = "#{@rocket_name} has not been installed"
      end
      redirect_to admin_rockets_path
    end

    def uninstall_rocket
      if params[:rocket]
        Rocket.uninstall(params[:rocket])
        redirect_to admin_rockets_path
      else
        render :rockets, notice: 'Rocket don\'t found! :('
      end
    end

    def build_rocket
      if params[:rocket]
        rocket_built = Rocket.build(params[:rocket])
        flash[:built] = "Rocket has #{'not' unless rocket_built} been updated"
        redirect_to admin_rockets_path
      else
        render :rockets, notice: 'Rocket don\'t found! :('
      end
    end

    private

    def rocket_params
      @rocket_file = params[:rocket]
      @rocket_name = @rocket_file.original_filename.split('.').first
      @rocket_ext = @rocket_file.original_filename.split('.').last
    end
  end
end
