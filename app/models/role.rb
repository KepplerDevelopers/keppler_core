# frozen_string_literal: true

# Role model
class Role < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :users_roles
  belongs_to :resource,
             polymorphic: true,
             optional: true
  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true
  scopify
  validates_uniqueness_of :name
  has_many :permissions
  def self.search_field
    :name_cont
  end

  def have_permissions?
    !permissions.empty?
  end

  def all_permissions
    permissions.first&.modules
  end

  def have_permission_to(module_name)
    !all_permissions[module_name].nil?
  end

  def have_action?(module_name, action)
    if all_permissions && !all_permissions[module_name].nil?
      all_permissions[module_name]['actions'].include?(action)
    end
  end

  def add_action(module_name, action)
    permissions.first.update(modules: create_hash('add', module_name, action))
  end

  def remove_action(module_name, action)
    permissions.first.update(modules: create_hash('remove', module_name, action))
  end

  def toggle_action(module_name, action)
    if have_action?(module_name, action)
      remove_action(module_name, action)
    else
      add_action(module_name, action)
    end
  end

  def add_module(module_name, action)
    old_hash = all_permissions
    new_hash = Hash[module_name, Hash['actions', Array(action)]]
    permissions.first.update(modules: old_hash.merge(new_hash))
  end

  def create_hash(act, module_name, action)
    old_hash = all_permissions
    arr = old_hash.dig(module_name, 'actions')

    act.eql?('add') ? arr.push(action) : arr.delete_if { |a| a.eql?(action) }

    new_hash = Hash[module_name, Hash['actions', arr]]
    old_hash.merge(new_hash)
  end
end
