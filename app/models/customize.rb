# frozen_string_literal: true

# Customize Model
class Customize < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  mount_uploader :file, TemplateUploader
  delegate :install, :uninstall, :set_defaut,
           to: :template

  # validates :file, uniqueness: true
  # Fields for the search form in the navbar
  def self.search_field
    :file_cont
  end

  def name
    if file?
      template.name(file)
    else
      'Keppler Default'
    end
  end

  private

  def template
    Admin::TemplateService.new(file)
  end
end
