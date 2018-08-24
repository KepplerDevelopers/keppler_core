module KepplerCapsules
  class CapsuleField < ApplicationRecord
    include KepplerCapsules::Concerns::StringActions
    include KepplerCapsules::Concerns::GeneratorActions
    belongs_to :capsule
    validates_presence_of :name_field
    before_validation :convert_to_downcase, :without_special_characters


    def destroy_migrate
      delete_field_pg_table("keppler_capsules_#{self.capsule.name}", self.name_field)
      system('rake keppler_capsules:install:migrations')
      system('rake db:migrate')
    end

    def formats
      [ :string, :text, :integer, :float, :decimal, :date, :boolean, :association ]
    end

    private

    def convert_to_downcase
      self.name_field.downcase!
    end

    def without_special_characters
      self.name_field.gsub!(' ', '_')
      special_characters.each { |sc| self.name_field.gsub!(sc, '') }
    end
  end
end
