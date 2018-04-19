# SmtpSetting Model
class SmtpSetting < ApplicationRecord
  belongs_to :setting
  validates_presence_of :address, :port, :domain_name, :email, :password
end
