# Keppler
module KepplerModel
  extend ActiveSupport::Concern

  # Class Methods
  module ClassMethods
    def clone_record(id)
      object = name.constantize.find(id)
      new_object = object.dup

      name.constantize.unique_attributes.each do |attr|
        if new_object.try(attr).class == String
          value = new_object.try(attr).strip.insert(-1, ' (Copy)')
          new_object.try(attr).replace(value)
        end
      end

      new_object
    end

    def unique_attributes
      name.constantize.validators.collect do |validation|
        validation if validation.class == ActiveRecord::Validations::PresenceValidator
      end.compact.collect(&:attributes).flatten.uniq
    end
  end
end
