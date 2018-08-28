# CallbackFunction Model
module KepplerFrontend
  class CallbackFunction < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    include KepplerFrontend::Concerns::CallbackFile
    include KepplerFrontend::Concerns::StringActions
    require 'csv'
    acts_as_list
    validates_presence_of :name
    validates_uniqueness_of :name
    before_validation :convert_to_downcase, :without_special_characters
    before_destroy :uninstall_callback

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


    def self.build_query(fields, operator, conf)
      query = fields.join("_#{operator}_")
      query << "_#{conf}"
      query.to_sym
    end

    def code_save(code, type_code)
      if type_code.eql?('callback')
        save_callback(code)
      end
    end

    private

    def uninstall_callback
      self.delete_callback
    end

    def convert_to_downcase
      self.name.downcase!
    end

    def without_special_characters
      self.name = self.name.split('').select { |x| x if not_special_chars.include?(x) } .join
    end
  end
end
