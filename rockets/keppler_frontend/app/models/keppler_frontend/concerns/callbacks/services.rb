# frozen_string_literal: true

# HtmlFile Module
module KepplerFrontend
  module Concerns
    module Callbacks
      module Services
        extend ActiveSupport::Concern

        included do
          delegate :install, :uninstall, to: :callbacks
        end

        private

        def callbacks
          KepplerFrontend::Callbacks::CodeHandler.new(self)
        end  
      end
    end
  end
end