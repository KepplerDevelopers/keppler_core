# Establishment Model
class Establishment < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  require 'csv'

  # Fields for the search form in the navbar
  def self.search_field
    :name_or_city_or_email_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Establishment.create! row.to_hash
      rescue => err
      end
    end
  end
end
