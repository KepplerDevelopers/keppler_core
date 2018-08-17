# frozen_string_literal: true

# ActionsOnDatabase Module
module KepplerCapsules
  module Concerns
    module ValidationActions
      extend ActiveSupport::Concern

      private

      def url_capsule
        "#{Rails.root}/rockets/keppler_capsules"
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
        line = "    #{validation_line(validation)}\n"
        result = code.include?(line) ? code.find_index(line) : 0
      end

      def delete_validation(table, validation)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        validation_index = search_validation_line(table, validation)
        code = File.readlines(file)
        if validation_index > 0
          code.delete_at(validation_index)
        end
        code = code.join('')
        File.write(file, code)
      end
    end
  end
end
