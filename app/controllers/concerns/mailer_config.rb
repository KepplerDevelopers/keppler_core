# frozen_string_literal: true

# MailerConfig
module MailerConfig
  extend ActiveSupport::Concern

  private

  def setting
    SmtpSetting.first
  end

  def smtp
    ActionMailer::Base
  end

  def set_mailer_settings
    smtp.smtp_settings = {
      address: setting.address,
      port: setting.port,
      domain: setting.domain_name,
      authentication: 'plain',
      user_name: setting.email,
      password: setting.password
    }
    other_settings
  end

  def other_settings
    smtp.default_url_options = { host: setting.domain_name }
    smtp.raise_delivery_errors = true
    smtp.delivery_method = :smtp
    smtp.perform_deliveries = true
    smtp.default charset: 'utf-8'
    Devise.mailer_sender = "no-reply@#{setting.domain_name}"
  end
end
