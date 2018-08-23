# frozen_string_literal: true

# ActionsOnDatabase Module
module KepplerCapsules
  module Concerns
    module AssociationActions
      extend ActiveSupport::Concern

      private

      def url_capsule
        "#{Rails.root}/rockets/keppler_capsules"
      end

      def add_association_to(table, association)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        code = File.readlines(file)
        head_idx = 0
        code.each do |i|
          head_idx = code.find_index(i) if i.include?("    # Begin associations area (don't delete)")
        end
        if search_association_line(table, association) == 0
          code.insert(head_idx.to_i + 1, "    #{association_line(association)}\n")
        end
        code = code.join('')
        File.write(file, code)
      end

      #[:belongs_to, :has_one, :has_many, :has_and_belongs_to_many]
      def association_line(association)
        dependent_destroy = dependention_true?(association) ? ", dependent: :destroy" : ""
        association_list = {
          :belongs_to => "belongs_to :#{association[:capsule_name].singularize}#{dependent_destroy}",
          :has_one => "has_one :#{association[:capsule_name].singularize}#{dependent_destroy}",
          :has_many => "has_many :#{association[:capsule_name].pluralize}#{dependent_destroy}",
          :has_and_belongs_to_many => "has_and_belongs_to_many :#{association[:capsule_name].pluralize}#{dependent_destroy}"
        }
        association_list[association[:association_type].to_sym]
      end

      def search_association_line(table, association)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        code = File.readlines(file)
        line = "    #{association_line(association)}\n"
        result = code.include?(line) ? code.find_index(line) : 0
      end

      def add_mount_image(table, field)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        code = File.readlines(file)
        head_idx = 0
        code.each do |i|
          head_idx = code.find_index(i) if i.include?("    require 'csv'")
        end
        code.insert(head_idx.to_i + 1, "    mount_uploader :#{field}, AttachmentUploader\n")
        code = code.join('')
        File.write(file, code)
      end

      def delete_association(table, association)
        file = "#{url_capsule}/app/models/keppler_capsules/#{table.singularize}.rb"
        association_index = search_association_line(table, association)
        code = File.readlines(file)
        if association_index > 0
          code.delete_at(association_index)
        end
        code = code.join('')
        File.write(file, code)
      end

      def dependention_true?(obj)
        association = obj[:dependention_destroy]
        association.eql?("true") || association.eql?(true)
      end
    end
  end
end
