# frozen_string_literal: true

# ApplicationMailer
class ApplicationMailer < ActionMailer::Base
  default from: 'testing@keppler.com'
  layout 'mailers/mailer'

  after_action :set_smtp

  def testing
    mail to: 'example@keppler.com', subject: 'Keppler email'
  end

  private

  def set_smtp
    setting = set_setting
    return if setting.address == 'test'
    mail_config.merge!(
      address: setting.address,
      port: setting.port,
      domain: setting.domain_name,
      user_name: setting.email,
      password: setting.password
    )
    set_default_option.merge!(host: setting.domain_name)
  end

  def set_setting
    setting = Setting.first
    setting.smtp_setting
  end

  def set_default_option
    ApplicationMailer.default_url_options
  end

  def mail_config
    config = mail.delivery_method
    config.settings
  end
end
