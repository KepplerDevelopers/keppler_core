module KepplerCapsules
  class CapsuleValidation < ApplicationRecord
    include KepplerCapsules::Concerns::StringActions
    include KepplerCapsules::Concerns::ActionsOnDatabase
    validates_presence_of :name, :field
    belongs_to :capsule

    def simple_validations
      [:validates_presence_of, :validates_numericality_of, :validates_uniqueness_of,
       :validates_numericality_integer_on, :validates_email_format_on,
       :validates_max_number, :validates_min_number, :validates_format_of,
       :validates_character_quantity_of ]
    end

    def delete_validation_line
      delete_validation(self.capsule.name, self)
    end
  end
end
