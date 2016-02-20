# Setting Model
class Setting < ActiveRecord::Base
  include ActivityHistory

  has_one :smtp_setting
  has_one :google_analytics_setting
  has_one :social_account
  has_one :appearance

  accepts_nested_attributes_for(
    :smtp_setting, :google_analytics_setting,
    :social_account, :appearance
  )

  mount_uploader :favicon, AttachmentUploader
  mount_uploader :logo, AttachmentUploader
end
