# frozen_string_literal: true

# Permission
class Permission < ApplicationRecord
  belongs_to :role
  after_update :build_yml

  def build_yml
    objects = Role.where.not(name: 'keppler_admin')
    data = objects.map { |o| [o.name, o.all_permissions] }.to_h.to_yaml
    File.write(file, data)
  end

  private

  def file
    "#{Rails.root}/config/roles.yml"
  end
end
