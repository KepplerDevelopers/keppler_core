# Gallery Model
class Gallery < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  has_many :photos, :dependent => :delete_all
  require 'csv'
  acts_as_list
  # Fields for the search form in the navbar
  def self.search_field
    :name_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Gallery.create! row.to_hash
      rescue => err
      end
    end
  end
end
