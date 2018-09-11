# Function Model
module KepplerFrontend
  class Function < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    acts_as_paranoid
    before_save :underscore_and_downcase_name
    before_destroy :delete_function
    before_validation :without_special_characters

    include KepplerFrontend::Concerns::Functions::FunctionsFile
    include KepplerFrontend::Concerns::StringActions

    has_many :parameters, dependent: :destroy, inverse_of: :function
    accepts_nested_attributes_for :parameters, reject_if: :all_blank, allow_destroy: true

    validates_presence_of :name, :description
    validates_uniqueness_of :name

    def underscore_and_downcase_name
      self.name = self.name.split(' ').join('_').downcase
    end

    def parse_parameters
      params = self.parameters.map { |p| p.name }
      params.split(' ').join(', ')
    end

    # Fields for the search form in the navbar
    def self.search_field
      fields = ["name", "description", "position", "deleted_at"]
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
end
