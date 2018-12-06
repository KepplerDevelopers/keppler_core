# View Model
module KepplerFrontend
  class View < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    include KepplerFrontend::Concerns::StringActions
    include KepplerFrontend::Concerns::CallbackActions
    include KepplerFrontend::Concerns::Views::Services
    require 'csv'
    acts_as_list
    validates_presence_of :name, :url
    validates_uniqueness_of :name, :url
    before_validation :convert_to_downcase, :without_special_characters
    has_many :view_callbacks, dependent: :destroy, inverse_of: :view
    accepts_nested_attributes_for :view_callbacks, reject_if: :all_blank, allow_destroy: true
    

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

    def path
      "#{name}_path"
    end

    def route
      "/admin/frontend/views/#{self.id}/editor"
    end

    def new_callback(callbacks)
      return unless callbacks
      callbacks.each do |key, value|
        next unless value[:name]
        callback = ViewCallback.where(name: value[:name], function_type: value[:function_type])
        callback_view(callback.first).add if callback.count == 1
      end
      true
    rescue StandardError
      false
    end

    def remove_callback(callback)
      callback_view(callback).remove
    end

    private

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end

    def convert_to_downcase
      self.url.downcase!
      self.name.downcase!
    end

    def without_special_characters
      self.name = self.name.split('').select { |x| x if not_special_chars.include?(x) } .join
      self.url = self.url.split('').select { |x| x if not_special_chars.include?(x) || x.eql?('/')} .join
    end
  end
end
