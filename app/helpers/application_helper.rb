# frozen_string_literal: true

# ApplicationHelper -> Helpers base
module ApplicationHelper
  # Title dinamic in all keppler
  def title(page_title)
    content_for(:title) { page_title }
  end

  # Meta Descriotion dinamic in all keppler
  def meta_description(page_description)
    content_for(:description) { page_description }
  end

  # True if a user is logged
  def loggedin?
    current_user
  end

  def can?(model)
    Pundit.policy(current_user, model)
  end

  def landing?
    controller_name.eql?('front') && action_name.eql?('index')
  end

  # For Keppler File Inputs
  def attach(attachments, type_or_formats)
    @attachments[attachments][type_or_formats]
  end

  def attach_singular?(symbols, t_or_f, name)
    attach(symbols, t_or_f).map(&:singularize).include?(name)
  end

  def attach_plural?(symbols, t_or_f, name)
    attach(symbols, t_or_f).map(&:pluralize).include?(name)
  end

  #----- For Keppler Input Tag
  def multimedia_tag(value)
    content_tag(:span, id: "value-#{value.__id__}") do
      if value.content_type.include?('image')
        image_tag value.url unless value.url.blank?
      elsif %w[audio text].include?(value.content_type.split('/').first)
        audio_text(value)
      else
        application_tag(value)
      end
    end
  end

  private

  def audio_text(value)
    if value.content_type.include?('audio')
      audio_tag value.url, controls: true unless value.url.blank? do
        media_tring(value)
      end
    else
      text_route = "#{Rails.root}/public/#{value}"
      raw File.readlines(text_route).join
    end
  end

  def application_tag(value)
    if attach(:videos, :formats).include?(value.content_type.split('/').last)
      video_tag value.url, controls: true unless value.url.blank? do
        media_tring(value)
      end
    elsif value.content_type.include?('pdf')
      pdf_tag(value)
    else
      extra_tag(value)
    end
  end

  def pdf_tag(value)
    javascript_tag do
      "PDFObject.embed('#{value.url}', '#value-#{value.__id__}', {
        'height': '100px',
        'width': '100%'
      })".html_safe
    end
  end

  def extra_tag(value)
    link_to value.url.split('/').last, download: value.url
  end

  def media_tring(value)
    t('keppler.messages.not_supported')
    link_to 'download it', value.url
    t('keppler.messages.enjoy_it')
  end
  #----- For Keppler Input Tag
end
