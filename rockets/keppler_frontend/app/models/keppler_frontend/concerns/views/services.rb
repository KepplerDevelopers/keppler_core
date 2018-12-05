# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Views
      module Services
        extend ActiveSupport::Concern

        included do
          delegate :install, :install_html, :install_remote_js, :install_only_action, to: :view_install_files
          delegate :change_name, to: :view_update_files
          delegate :uninstall, :uninstall_html, :uninstall_remote_js, :uninstall_only_action, to: :view_uninstall_files
          delegate :install, :uninstall, to: :routes, prefix: true
          delegate :html, :scss, :action, :js, :remote_js, to: :output, prefix: true
          delegate :code, to: :save_service, prefix: 'save'
        end

        private

        def routes
          KepplerFrontend::Views::RoutesHandler.new(self)
        end  
    
        def view_install_files
          KepplerFrontend::Views::Install.new(self)
        end
    
        def view_update_files
          KepplerFrontend::Views::Update.new(self)
        end
    
        def view_uninstall_files
          KepplerFrontend::Views::Uninstall.new(self)
        end
    
        def output
          KepplerFrontend::Views::Output.new(self)
        end
    
        def save_service
          KepplerFrontend::Views::Save.new(self)
        end

        def callback_view(callback)
          KepplerFrontend::Callbacks::CodeViews.new(self, callback)
        end
      end
    end
  end
end