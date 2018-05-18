# Script Model
class Script < ApplicationRecord
  include ActivityHistory
  include CloneRecord

  validates_presence_of :name, :script, :url

  def self.get_script(request)
    find_by_url(request.url)
  end

  def self.search_field
    :name_or_script_cont
  end

  def self.upload(file)
    CSV.foreach(file.path, headers: true) do |row|
      begin
        Script.create! row.to_hash
      rescue => err
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |script|
        csv << script.attributes.values
      end
    end
  end

  def self.sorter(params)
    params.each_with_index { |id, idx| find(id).update(position: idx.to_i + 1) }
  end
end
