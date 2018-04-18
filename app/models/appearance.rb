# Appearance Model
class Appearance < ApplicationRecord
  belongs_to :setting
  mount_uploader :image_background, AttachmentUploader
end
