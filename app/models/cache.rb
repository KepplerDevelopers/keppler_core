class Cache < ActiveRecord::Base
  mount_uploader :image, TemplateUploader
end
