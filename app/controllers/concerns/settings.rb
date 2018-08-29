# frozen_string_literal: true

# DeviseParams
module Settings
  extend ActiveSupport::Concern

  def basic_information_fields
    setting = Setting.first
    [
      Hash['name', setting.name],
      Hash['description', setting.description],
      Hash['email', setting.email],
      Hash['phone', setting.phone],
      Hash['mobile', setting.mobile]
    ]
  end

  def smtp_fields
    smtp = Setting.first.smtp_setting
    [
      Hash['address', smtp.address],
      Hash['port', smtp.port],
      Hash['domain_name', smtp.domain_name],
      Hash['smtp_email', smtp.email]
    ]
  end

  def google_analytics_fields
    google = Setting.first.google_analytics_setting

    [
      Hash['ga_account_id', google.ga_account_id],
      Hash['ga_tracking_id', google.ga_tracking_id],
      Hash['ga_status', google.ga_status]
    ]
  end

  def social_accounts_fields
    setting = Setting.first
    account = setting.social_account

    account_fields(account)
  end

  def appearance_fields
    fields = Setting.first.appearance

    [
      Hash['theme_name', fields.theme_name]
    ]
  end

  def update_settings_yml
    file = File.join("#{Rails.root}/config/settings.yml")

    data = basic_information_fields.push(
      smtp_fields,
      google_analytics_fields,
      social_accounts_fields,
      appearance_fields
    ).flatten.as_json.to_yaml

    File.write(file, data)
    delete_underscores(file)
  end

  def delete_underscores(file)
    yml = File.readlines(file)
    yml.each_with_index do |_line, index|
      if yml[index].include?('-') && yml[index] != "---\n"
        yml[index] = yml[index].tr('-', ' ')
        yml[index] = tracking_id(yml[index]) if yml[index].include?('UA')
      end
    end
    yml = yml.join('')
    File.write(file, yml)
  end

  private

  def tracking_id(string)
    return unless string.include?('UA')
    a = string.split(' ').last(3)
    b = a.first
    c = a.last(2).join('-')
    "  ga_tracking_id: #{b}-#{c}\n"
  end

  def socials
    %i[
      facebook twitter instagram google_plus
      tripadvisor pinterest flickr behance
      dribbble tumblr github linkedin
      soundcloud youtube skype vimeo
    ]
  end

  def account_fields(obj)
    social_accounts = socials.map do |social|
      Hash[social.to_s, obj[social.to_sym]]
    end

    social_accounts
  end
end
