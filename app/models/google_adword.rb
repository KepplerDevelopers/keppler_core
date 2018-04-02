# GoogleAdword Model
class GoogleAdword < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  validates_presence_of :url, :campaign_name, :script

  validates_uniqueness_of :url

  def self.get_by_url(url)
    find_by_url(url)
  end

  def self.search_field
    :campaign_name_or_description_cont
  end

  def self.import(file)
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
end
