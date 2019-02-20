# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Callbacks
      module Services
        extend ActiveSupport::Concern

        included do
          delegate :install, :change_name, :code_save, :output, :uninstall, to: :callbacks   
          before_destroy :callback_uninstall
        end

        private

        def callback_uninstall
          callbacks.uninstall
        end

        def callbacks
          KepplerFrontend::Callbacks::CodeHandler.new(self)
        end  
      end
    end
  end
end