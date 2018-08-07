# frozen_string_literal: true

# ActionsOnDatabase Module
module KepplerCapsules
  module Concerns
    module ActionsOnDatabase
      extend ActiveSupport::Concern

      private

      def url_capsule
        "#{Rails.root}/rockets/keppler_capsules"
      end

      def create_pg_table(table)
        migrate_id = generate_id_migrate
        migration = Dir.entries("#{url_capsule}/db/migrate").sort.last
        new_name = migration.split('_').insert(2, migrate_id.downcase).join('_')
        File.rename("#{url_capsule}/db/migrate/#{migration}", "#{url_capsule}/db/migrate/#{new_name}")
        file = File.readlines("#{url_capsule}/db/migrate/#{new_name}")
        file[0] = "class Create#{migrate_id}KepplerCapsules#{table.split('_').map(&:capitalize).join('')} < ActiveRecord::Migration[5.2]\n"
        file = file.join('')
        File.write("#{url_capsule}/db/migrate/#{new_name}", file)
      end

      def delete_pg_table(table)
        return unless table_exists?(table)
        migrate_id = generate_id_migrate
        system("cd rockets/keppler_capsules && rails g migration Drop#{migrate_id}#{table.split('_').map(&:capitalize).join('')}")
        migration = Dir.entries("#{url_capsule}/db/migrate").sort.last
        out_file = File.open("#{url_capsule}/db/migrate/#{migration}", "w")
        out_file.puts(migrate_delete_table_format(table, migrate_id));
        out_file.close
      end

      def add_field_pg_table(column, table)
        migrate_id = generate_id_migrate
        folder = 'cd rockets/keppler_capsules'
        fields = "#{column[:name_field]}:#{column[:format_field]}"
        command = "rails g migration add_#{migrate_id}_#{column[:name_field]}_to_keppler_capsules_#{table} #{fields}"
        system("#{folder} && #{command}")
      end

      def delete_field_pg_table(table, column)
        migrate_id = generate_id_migrate
        folder = 'cd rockets/keppler_capsules'
        command = "rails g migration remove_#{migrate_id}_#{column}_from_#{table}"
        system("#{folder} && #{command}")
        migration = Dir.entries("#{url_capsule}/db/migrate").sort.last
        out_file = File.open("#{url_capsule}/db/migrate/#{migration}", "w")
        out_file.puts(migrate_delete_column_format(table, column, migrate_id));
        out_file.close
      end

      def migrate_delete_table_format(table, migrate_id)
        table_class = table.split('_').map(&:capitalize).join('')
        [
          "class Drop#{migrate_id}#{table_class} < ActiveRecord::Migration[5.2]\n",
          "  def change\n",
          "    drop_table :#{table}\n",
          "  end\n",
          "end"
        ].join
      end

      def migrate_delete_column_format(table, column, migrate_id)
        table_class = table.split('_').map(&:capitalize).join('')
        column = column.split('_').map(&:capitalize).join('')
        [
          "class Remove#{migrate_id}#{column}From#{table_class} < ActiveRecord::Migration[5.2]\n",
          "  def change\n",
          "    remove_column :#{table}, :#{column.downcase}\n",
          "  end\n",
          "end"
        ].join
      end

      def generate_id_migrate
        o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
        string = (0...10).map { o[rand(o.length)] }.join
        string = string.downcase.capitalize
      end

      def add_validation_to(table, validation)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        code = File.readlines(file)
        head_idx = 0
        code.each do |i|
          head_idx = code.find_index(i) if i.include?("    # Begin validations area (don't delete)")
        end
        if search_validation_line(table, validation) == 0
          code.insert(head_idx.to_i + 1, "    #{validation_line(validation)}\n")
        end
        code = code.join('')
        File.write(file, code)
      end

      def validation_line(validation)
        validation_list = {
          :validates_presence_of => "validates_presence_of :#{validation[:field]}",
          :validates_numericality_of => "validates_numericality_of :#{validation[:field]}",
          :validates_numericality_integer_on => "validates :#{validation[:field]}, :numericality => { :only_integer => true }",
          :validates_uniqueness_of => "validates_uniqueness_of :#{validation[:field]}",
          :validates_email_format_on => "validates :#{validation[:field]}, format: { with: URI::MailTo::EMAIL_REGEXP }",
          :validates_max_number => "validates :#{validation[:field]}, length: { maximum: #{validation[:validation]} }",
          :validates_min_number => "validates :#{validation[:field]}, length: { minimum: #{validation[:validation]} }",
          :validates_character_quantity_of => "validates :#{validation[:field]}, length: { is: #{validation[:validation] }",
          :validates_format_of => "validates :#{validation[:field]}, format: { with: #{validation[:validation]} }"
        }
        validation_list[validation[:name].to_sym]
      end

      def search_validation_line(table, validation)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        code = File.readlines(file)
        result = 0
        code.each do |i|
          result = code.find_index(i) if i.include?("    #{validation_line(validation)}\n")
        end
        result
      end

      def delete_validation(table, validation)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        validation_index = search_validation_line(table, validation)
        code = File.readlines(file)
        code.delete_at(validation_index)
        code = code.join('')
        File.write(file, code)
      end

      def table_exists?(table)
        ActiveRecord::Base.connection.table_exists?(table)
      end
    end
  end
end
