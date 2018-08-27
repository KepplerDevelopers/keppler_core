# Language Model
module KepplerLanguages
  class Language < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    before_destroy :delete_yml

    include KepplerLanguages::Concerns::YmlFile

    validates_presence_of :name
    validates_uniqueness_of :name
    has_many :fields

    has_many :fields, dependent: :destroy, inverse_of: :language
    accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true

    
    # Fields for the search form in the navbar
    def self.search_field
      fields = ["name", "position", "deleted_at"]
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

    def install_yml
      create_yml
    end
  end
end
