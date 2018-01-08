# Scaffold Model
class Scaffold < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  require 'csv'

  # Fields for the search form in the navbar
  def self.search_field
    :name_or_fields_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Scaffold.create! row.to_hash
      rescue => err
      end
    end
  end
end
