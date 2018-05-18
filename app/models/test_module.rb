# frozen_string_literal: true

# TestModule Model
class TestModule < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  require 'csv'
  mount_uploader :image, AttachmentUploader
  acts_as_list
  acts_as_paranoid

  # Fields for the search form in the navbar
  def self.search_field
    fields = ["name", "image", "position", "deleted_at"]
    build_query(fields, :or, :cont)
  end

  def self.upload(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        self.create! row.to_hash
      rescue => err
      end
    end
  end

  def self.sorter(params)
    params.each_with_index do |id, idx|
      self.find(id).update(position: idx.to_i+1)
    end
  end

  # Funcion para armar el query de ransack
  def self.build_query(fields, operator, conf)
    query = fields.join("_#{operator}_")
    query << "_#{conf}"
    query.to_sym
  end
end
