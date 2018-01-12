Recaptcha.configure do |config|
  config.site_key = Rails.application.secrets.site_key
  config.secret_key = Rails.application.secrets.secret_key
end
