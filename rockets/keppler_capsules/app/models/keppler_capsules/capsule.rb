# Capsule Model
module KepplerCapsules
  class Capsule < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    include KepplerCapsules::Concerns::GeneratorActions
    include KepplerCapsules::Concerns::ValidationActions
    include KepplerCapsules::Concerns::AssociationActions
    include KepplerCapsules::Concerns::StringActions
    require 'csv'
    acts_as_list
    has_many :capsule_fields, dependent: :destroy, inverse_of: :capsule
    has_many :capsule_validations, dependent: :destroy, inverse_of: :capsule
    has_many :capsule_associations, dependent: :destroy, inverse_of: :capsule
    before_destroy :uninstall
    accepts_nested_attributes_for :capsule_fields, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :capsule_validations, reject_if: :all_blank, allow_destroy: true
    accepts_nested_attributes_for :capsule_associations, reject_if: :all_blank, allow_destroy: true

    validates_presence_of :name
    validates_uniqueness_of :name
    before_validation :without_special_characters


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

    def install
      return if table_exists?("keppler_capsules_#{self.name}")
      fields = self.capsule_fields.map { |f| "#{f.name_field}:#{f.format_field}" }
      fields = fields.join(' ')
      system("cd rockets/keppler_capsules && rails g keppler_capsule_scaffold #{self.name} #{fields} position:integer deleted_at:datetime:index")
      create_pg_table(self.name)
      system('rake keppler_capsules:install:migrations')
      system('rake db:migrate')
    end

    def uninstall
      return unless table_exists?("keppler_capsules_#{self.name}")
      system("cd rockets/keppler_capsules && rails d keppler_capsule_scaffold #{self.name}")
      FileUtils.rm_rf("#{url_capsule}/app/views/keppler_capsules/admin/#{self.name}")
      delete_pg_table("keppler_capsules_#{self.name}")
      system('rake keppler_capsules:install:migrations')
      system('rake db:migrate')
    end

    def new_attributes(table, attributes)
      attributes.each do |key, value|
        if value[:name_field]
          field = CapsuleField.where(name_field: value[:name_field])
          add_mount_image(table, value[:name_field]) if attachments.include?(value[:name_field])
          if field.count <= 1
            add_field_pg_table(value, table)
          else
            field.last.delete
          end
        end
      end
      system('rake keppler_capsules:install:migrations')
      system('rake db:migrate')
    end

    def new_validations(table, attributes)
      return unless attributes
      attributes.each do |key, value|
        if value[:name]
          validation = CapsuleValidation.where(name: value[:name], field: value[:field])
          add_validation_to(table, value) if validation.count == 1
        end
      end
    end

    def new_associations(table, associations)
      return unless associations
      associations.each do |key, value|
        if value[:association_type]
          association = CapsuleAssociation.where(
            association_type: value[:association_type],
            capsule_name: value[:capsule_name],
            capsule_id: self.id)
          add_association_to(table, value) if association.count == 1
          if value[:association_type].eql?('belongs_to')
            CapsuleField.create(name_field: "#{value[:capsule_name].singularize}_id", format_field: 'association', capsule_id: self.id)
            attributes = { "0" =>{ name_field: "#{value[:capsule_name].singularize}_id", format_field: 'integer' }}
            new_attributes(table, attributes)
          end
        end
      end
    end

    private

    def without_special_characters
      self.name.gsub!(' ', '_')
      special_characters.each { |sc| self.name.gsub!(sc, '') }
    end

    def table_exists?(table)
      ActiveRecord::Base.connection.table_exists?(table)
    end

    def attachments
      ['logo', 'brand', 'photo', 'avatar', 'cover', 'image',
       'picture', 'banner', 'attachment', 'pic', 'file']
    end

  end
end
