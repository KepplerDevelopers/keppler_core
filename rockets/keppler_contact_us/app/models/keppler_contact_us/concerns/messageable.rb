# frozen_string_literal: true

# KepplerContactUs
module KepplerContactUs
  module Concerns
    module Messageable
      extend ActiveSupport::Concern
      included do
        def self.sent
          all.where(from_email: current_user.email)
        end 

        def self.select_all(attr)
          all.select(&:attr)
        end

        def self.reject_all(attr)
          all.reject(&:read)
        end

        def self.unread_count
          all.reject(&:read).count
        end
      end
    end
  end
end