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

  def permissions?
    !permissions.empty?
  end

  def all_permissions
    permissions.first&.modules
  end

  def permission_to(module_name)
    !all_permissions[module_name].nil?
  end

  def action?(module_name, action)
    permit = all_permissions
    return unless permit && !permit[module_name].nil?
    permit[module_name]['actions'].include?(action)
  end

  def toggle_actions(module_name, action)
    if permission_to(module_name)
      update_action(module_name, action)
    else
      add_module(module_name, action)
    end
  end

  def first_permission(module_name, action)
    Permission.create(
      role_id: id,
      modules: Hash[module_name, Hash['actions', Array(action)]]
    )
  end

  private

  def add_action(module_name, action)
    permission = permissions.first
    permission.update(modules: create_hash('add', module_name, action))
  end

  def remove_action(module_name, action)
    permission = permissions.first
    permission.update(modules: create_hash('remove', module_name, action))
  end

  def update_action(module_name, action)
    if action?(module_name, action)
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
