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
    controller_path
      .remove('app/').remove('admin/')
      .classify.constantize
  end

  # Underscore class_name from a object
  def underscore(object)
    object.class.to_s.underscore
  end

  # Messages for the crud actions
  def actions_messages(_object)
    t(
      "keppler.messages.successfully.#{action_convert_to_locale}",
      model: t(
        "keppler.models.singularize.#{controller_name.singularize}"
      ).humanize
    )
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

  def included_in?(array1, array2)
    !(array1 & array2).blank?
  end

  def allowed_action?(module_name, actions)
    !current_user.roles.first.include_actions?(module_name, actions).blank?
  end

  private

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

  # ------------ actions_messages(object)
  def action_convert_to_locale
    case action_name
    when 'clone' then 'cloned'
    when 'create' then 'created'
    when 'update' then 'updated'
    when 'destroy' then 'deleted'
    when 'destroy_multiple' then 'removed'
    end
  end
  # ------------ actions_messages(object)

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
