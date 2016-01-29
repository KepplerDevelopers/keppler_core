class Setting < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_one :smtp_setting
  has_one :google_analytics_setting
  has_one :social_account
  accepts_nested_attributes_for :smtp_setting, :google_analytics_setting, :social_account

  mount_uploader :favicon, AttachmentUploader
  mount_uploader :logo, AttachmentUploader

end
