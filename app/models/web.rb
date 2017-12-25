# Web Model
class Web < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord
  require 'csv'

  # Fields for the search form in the navbar
  def self.search_field
    :name_or_description_or_date_or_pay_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Web.create! row.to_hash
      rescue => err
      end
    end
  end
end
