# frozen_string_literal: true

module Ckeditor
  # Ckeditor::Asset model
  class Asset < ActiveRecord::Base
    include Ckeditor::Orm::ActiveRecord::AssetBase

    delegate :url, :current_path, :content_type, to: :data

    validates :data, presence: true
  end
end
