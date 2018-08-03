module KepplerCapsules
  class CapsuleField < ApplicationRecord
    belongs_to :capsule
    validates_presence_of :name_field
    before_validation :convert_to_downcase, :without_special_characters

    private

    def convert_to_downcase
      self.name_field.downcase!
    end

    def without_special_characters
      self.name_field.gsub!(' ', '_')
      special_characters.each { |sc| self.name_field.gsub!(sc, '') }
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
  end
end
