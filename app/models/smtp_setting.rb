# SmtpSetting Model
class SmtpSetting < ActiveRecord::Base
  belongs_to :setting
  validates_presence_of :server_address, :port, :domain_name, :email, :password
end
