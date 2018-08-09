module KepplerCapsules
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module YmlSave
      extend ActiveSupport::Concern

      included do
      end

      private

      def reload_capsules
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsules.yml")
        capsules = YAML.load_file(file)
        if capsules
          capsules.each do |capsule|
            capsule_db = KepplerCapsules::Capsule.where(name: capsule['name']).first
            unless capsule_db
              KepplerCapsules::Capsule.create(
                name: capsule['name']
              )
            end
          end
        end
      end

      def reload_capsule_fields
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsule_fields.yml")
        capsule_fields = YAML.load_file(file)
        if capsule_fields
          capsule_fields.each do |capsule_field|
            capsule_db = KepplerCapsules::CapsuleField.where(name_field: capsule_field['name_field']).first
            unless capsule_db
              KepplerCapsules::CapsuleField.create(
                name_field: capsule_field['name_field'],
                format_field: capsule_field['format_field']
              )
            end
          end
        end
      end

      def reload_capsule_validations
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsule_validations.yml")
        capsule_fields = YAML.load_file(file)
        if capsule_fields
          capsule_fields.each do |capsule_validations|
            capsule_db = KepplerCapsules::CapsuleValidation.where(id: capsule_validations['id']).first
            unless capsule_db
              KepplerCapsules::CapsuleValidation.create(
                name: capsule_validations['name'],
                field: capsule_validations['field'],
                validation: capsule_validations['validation']
              )
            end
          end
        end
      end

      def reload_capsule_associations
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsule_associations.yml")
        capsule_fields = YAML.load_file(file)
        if capsule_fields
          capsule_fields.each do |capsule_associations|
            capsule_db = KepplerCapsules::CapsuleAssociation.where(id: capsule_associations['id']).first
            unless capsule_db
              KepplerCapsules::CapsuleAssociation.create(
                association_type: capsule_associations['name'],
                capsule_name: capsule_associations['field'],
                dependention_destroy: capsule_associations['validation']
              )
            end
          end
        end
      end

      def update_capsules_yml
        capsules = KepplerCapsules::Capsule.all
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsules.yml")
        data = capsules.as_json.to_yaml
        File.write(file, data)
      end

      def update_capsule_fields_yml
        capsule_fields = KepplerCapsules::CapsuleField.all
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsule_fields.yml")
        data = capsule_fields.as_json.to_yaml
        File.write(file, data)
      end

      def update_capsule_validations_yml
        capsules = KepplerCapsules::CapsuleValidation.all
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsule_validations.yml")
        data = capsules.as_json.to_yaml
        File.write(file, data)
      end

      def update_capsule_associations_yml
        capsules = KepplerCapsules::CapsuleAssociation.all
        file =  File.join("#{Rails.root}/rockets/keppler_capsules/config/capsule_associations.yml")
        data = capsules.as_json.to_yaml
        File.write(file, data)
      end
    end
  end
end
