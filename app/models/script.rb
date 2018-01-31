# Script Model
class Script < ActiveRecord::Base
  include ActivityHistory
  include CloneRecord

  validates_presence_of :name, :script, :url

  def self.get_script(request)
    find_by_url(request.url)
  end

  def self.search_field
    :name_or_script_cont
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Script.create! row.to_hash
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
