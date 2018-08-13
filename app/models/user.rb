# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  include ActivityHistory
  # mount_uploader :avatar, TemplateUploader
  before_save :create_permalink, if: :new_record?
  rolify
  validates_presence_of :name, :role_ids, :email
  mount_uploader :avatar, AttachmentUploader
  acts_as_paranoid

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def rol
    roles.first.name
  end

  def permissions?
    roles.first.permissions?
  end

  def self.filter_by_role(obj, role_id)
    obj.select { |u| u.rol.eql?(role_id) }
  end

  # Get the page number that the object belongs to
  def page(order = :id)
    ((self.class.order(order => :desc)
      .pluck(order).index(send(order)) + 1)
        .to_f / self.class.default_per_page).ceil
  end

  def self.search_field
    :name_or_username_or_email_cont
  end

  def keppler_admin?
    rol.eql?('keppler_admin')
  end

  def admin?
    rol.eql?('admin')
  end

  def can?(model_name, method)
    return if permissions.nil? || permissions[model_name].nil?
    permissions[model_name]['actions'].include?(method) || false
  end

  def permissions
    return if roles.first.permissions.blank?
    roles.first.permissions.first.modules
  end

  private

  def create_permalink
    self.permalink = name.downcase.parameterize + '-' + SecureRandom.hex(4)
  end
end
