module KepplerCapsules
  class CapsuleAssociation < ApplicationRecord
    include KepplerCapsules::Concerns::StringActions
    include KepplerCapsules::Concerns::GeneratorActions
    include KepplerCapsules::Concerns::AssociationActions
    belongs_to :capsule
    validate :uniqueness_association

    def relationships
      [:belongs_to, :has_one, :has_many, :has_and_belongs_to_many]
    end

    def dependentions
      [[false, :nothing], [true, :destroy]]
    end

    def capsules_valids
      Capsule.all.select { |x| x unless x.name.eql?(self.capsule.name) }
    end

    def delete_association_line
      delete_association(self.capsule.name, self)
    end

    def association_exists?
      association = CapsuleAssociation.where(
        capsule_id: self.capsule,
        association_type: self.association_type,
        capsule_name: self.capsule_name)
      association.count == 0 ? false : true
    end

    private

    def uniqueness_association
      errors.add(:association_type, :uniqueness_association) if association_exists?
    end
  end
end
