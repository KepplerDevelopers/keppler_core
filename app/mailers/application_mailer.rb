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
    setting = Setting.first.smtp_setting
    return if setting.address == 'test'
    mail.delivery_method.settings.merge!(
      address: setting.address,
      port: setting.port,
      domain: setting.domain_name,
      user_name: setting.email,
      password: setting.password
    )
    ApplicationMailer.default_url_options.merge!(host: setting.domain_name)
  end
end
