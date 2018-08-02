# frozen_string_literal: true

# Setting Model
class Setting < ApplicationRecord
  include ActivityHistory

  has_one :smtp_setting, dependent: :destroy
  has_one :google_analytics_setting, dependent: :destroy
  has_one :social_account, dependent: :destroy
  has_one :appearance, dependent: :destroy

  accepts_nested_attributes_for(
    :smtp_setting, :google_analytics_setting,
    :social_account, :appearance
  )

  mount_uploader :favicon, AttachmentUploader
  mount_uploader :logo, AttachmentUploader
end
