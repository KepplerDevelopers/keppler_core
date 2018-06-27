# frozen_string_literal: true

# AdminHelper Backoffice
module AdminHelper
  def keppler_boolean_script
    render 'admin/layouts/keppler_boolean_script'
  end

  def preloader
    render 'admin/layouts/preloader'
  end

  # Header information dinamic in keppler back-office
  def header_information(&block)
    content_for(:header_information) { capture(&block) }
  end

  # True if the index action of keppler
  def listing?
    action_name.to_sym.eql?(:index)
  end

  # True if the setting controller of keppler
  def settings_path?
    controller_name.eql?('settings')
  end

  # Classify a model from a controller
  def model
    ctrlpath = controller_path
    klass = ctrlpath.include?('admin') ? controller_name : controller_path
    klass.classify.constantize
  end

  # Underscore class_name from a object
  def underscore(object)
    object.class.to_s.underscore
  end

  # Messages for the crud actions
  def actions_messages(object)
    t("keppler.messages.successfully.#{action_convert_to_locale}",
      model: t("keppler.models.singularize.#{underscore(object)}").humanize)
  end

  def entries(total, objects)
    return if total.zero?
    content_tag :div,
                class: 'badge objects-counter',
                style: 'margin-bottom: 0 10px' do
      content_tag :span, class: 'span' do
        message(total, objects)
      end
    end
  end

  def search_model
    klass = controller_path.split('/')
    klass.delete('admin')
    klass = klass.join('/')
    klass.classify.constantize.search_field
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

  # ------------ preload
  def spinner_layer(_color)
    content_tag :div, class: "spinner-layer spinner-#{color}" do
      clipper('left') + gap_path + clipper('right')
    end
  end

  def clipper(direction)
    content_tag(
      :div,
      content_tag(:div, nil, class: 'circle'),
      class: "circle-clipper #{direction}"
    )
  end

  def gap_path
    content_tag(
      :div,
      content_tag(:div, nil, class: 'circle'),
      class: 'gap-path'
    )
  end
  # ------------ preload

  # ------------ action_message
  def action_convert_to_locale
    case action_name
    when 'create' then 'created'
    when 'update' then 'updated'
    when 'destroy' then 'deleted'
    when 'destroy_multiple' then 'removed'
    end
  end
  # ------------ action_message

  # ------------ entries
  def message(total, objects)
    if objects.first_page?
      t('keppler.messages.record_msg', from: 1, to: objects.size, total: total)
    elsif objects.last_page?
      t('keppler.messages.record_msg',
        from: from(objects), to: total, total: total)
    else
      t('keppler.messages.record_msg',
        from: from(objects), to: to(objects), total: total)
    end
  end

  # Calculate number that begins the page
  def from(objects)
    ((objects.current_page * objects.default_per_page) -
    objects.default_per_page) + 1
  end

  # Calculate the number that ends the page
  def to(objects)
    objects.current_page * objects.default_per_page
  end
  # ------------ entries
end
