class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true
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
    old_hash = all_permissions
    array = old_hash[module_name]['actions']
    array.push(action)
    new_hash = Hash[module_name, Hash['actions', array]]
    permissions.first.update(modules: old_hash.merge(new_hash))
  end

  def remove_action(module_name, action)
    old_hash = all_permissions
    array = old_hash[module_name]['actions']
    array = array.delete_if { |act| act.eql?(action) }
    new_hash = Hash[module_name, Hash['actions', array]]
    permissions.first.update(modules: old_hash.merge(new_hash))
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
end
