# Capsule Model
module KepplerCapsules
  class Capsule < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    require 'csv'
    acts_as_list
    has_many :capsule_fields, dependent: :destroy, inverse_of: :capsule
    before_destroy :uninstall
    accepts_nested_attributes_for :capsule_fields, reject_if: :all_blank, allow_destroy: true

    validates_presence_of :name
    validates_uniqueness_of :name
    before_validation :convert_to_downcase, :without_special_characters


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
      fields = self.capsule_fields.map { |f| "#{f.name_field}:#{f.format_field}" }
      fields = fields.join(' ')
      system("cd rockets/keppler_capsules && rails g keppler_capsule_scaffold #{self.name} #{fields} position:integer deleted_at:datetime:index")
      system('rake keppler_capsules:install:migrations')
      system('rake db:migrate')
    end

    def uninstall
      return unless self
      system("cd rockets/keppler_capsules && rails d keppler_capsule_scaffold #{self.name}")
      FileUtils.rm_rf("#{url_capsule}/app/views/keppler_capsules/admin/#{self.name}")
      delete_pg_table("keppler_capsules_#{self.name}")
      system('rake keppler_capsules:install:migrations')
      system('rake db:migrate')
    end

    private

    def url_capsule
      "#{Rails.root}/rockets/keppler_capsules"
    end

    def convert_to_downcase
      self.name.downcase!
    end

    def without_special_characters
      self.name.gsub!(' ', '_')
      special_characters.each { |sc| self.name.gsub!(sc, '') }
    end

    def special_characters
      [
        '/', '.', '@', '"', "'", '%', '&', '$',
        '?', '¿', '/', '=', ')', '(', '#', '{',
        '}', ',', ';', ':', '[', ']', '^', '`',
        '¨', '~', '+', '-', '*', '¡', '!', '|',
        '¬', '°', '<', '>', '·', '½'
      ]
    end

    def delete_pg_table(table)
      system("cd rockets/keppler_capsules && rails g migration Drop#{table.split('_').map(&:capitalize).join('')}")
      migration = Dir.entries("#{url_capsule}/db/migrate").sort.last
      out_file = File.open("#{url_capsule}/db/migrate/#{migration}", "w")
      out_file.puts(migrate_delete_format(table));
      out_file.close
    end

    def migrate_delete_format(table)
      [
        "class Drop#{table.split('_').map(&:capitalize).join('')} < ActiveRecord::Migration[5.2]\n",
        "  def change\n",
        "    drop_table :#{table}\n",
        "  end\n",
        "end"
      ].join
    end

  end
end
