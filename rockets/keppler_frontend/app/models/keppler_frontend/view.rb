# View Model
module KepplerFrontend
  class View < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    # Fields for the search form in the navbar
    def self.search_field
      fields = ['name', 'url', 'method', 'format_result']
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

    def color
      return 'olive' if ['GET', 'POST'].include?(method)
      return 'blue' if ['ROOT'].include?(method)
      return 'orange' if ['PATCH', 'PUT'].include?(method)
      return 'red' if ['DELETE'].include?(method)
    end
  end
end
