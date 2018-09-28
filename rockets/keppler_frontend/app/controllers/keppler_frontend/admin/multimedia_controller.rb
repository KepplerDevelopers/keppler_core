require_dependency "keppler_frontend/application_controller"
module KepplerFrontend
  module Admin
    # ViewsController
    class MultimediaController < ApplicationController
      layout 'keppler_frontend/admin/layouts/application'
      before_action :authorization
      before_action :set_filesystem      
      before_action :only_development
      skip_before_action :verify_authenticity_token, only: :upload

      def index
        set_data(@filesystem)
        flash[:notice] = [nil, 'images', 'success']
      end

      def upload
        uploader = ImgFileUploader.new
        tab = "images"
        message = "fail"
        unless params[:view].nil?
          fotmat_valid = @filesystem .validate_format(params[:view][:file].original_filename)
          message = "success"
          if fotmat_valid
            File.open(params[:view][:file].path) do |file|
              uploader.store!(file)
              @filesystem .move_and_rename_file(uploader, params[:view][:file])
            end
            filename = params[:view][:file].original_filename
            tab = select_tab(fotmat_valid, filename)
          else
            tab = "images"
            message = "fail"
          end
        end
        set_data(@filesystem )
        flash[:notice] = [ t("keppler_frontend.#{message}"), tab, message ]
        render :index
      end

      def destroy
        file = @filesystem .search_with_format(params[:search], params[:fileformat])[0]
        unless file.nil?
          fotmat_valid = @filesystem .validate_format(file[:name])
          tab = select_tab(fotmat_valid, file[:name])
          [:cover_url, :url].each { |atr| File.delete(file[atr]) if File.exist?(file[atr]) }
        else
          tab = select_tab_by_format(params[:fileformat])
        end
        set_data(@filesystem)
        flash[:notice] = [ t("keppler_frontend.destroy"), tab, "success" ]
        render :index
      end

      private

      def authorization
        authorize View
      end

      def set_filesystem
        @filesystem  = FileUploadSystem.new
      end

      def set_data(filesystem )
        @view = View.new
        @files_list = filesystem .files_list
      end

      def select_tab(fotmat_valid, file)
        return nil unless fotmat_valid
        @filesystem  = FileUploadSystem.new
        file = @filesystem .file_object(file)
        file[:folder]
      end

      def select_tab_by_format(content_type)
        filesystem  = FileUploadSystem.new
        file = filesystem .select_folder_by_format(content_type)
      end
    end
  end
end
