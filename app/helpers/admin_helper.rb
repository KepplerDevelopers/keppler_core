# AdminHelper Backoffice
module AdminHelper
  def preloader
    content_tag :div, class: 'preloader-wrapper big active' do
      concat spinner_layer('blue')
      concat spinner_layer('red')
      concat spinner_layer('yellow')
      concat spinner_layer('green')
    end
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
    klass = controller_path.include?('admin') ? controller_name : controller_path
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
    unless total.zero?
      content_tag :div, class: 'btn-group', style: "margin-bottom: 10px" do
        content_tag :button, class: 'btn btn-default' do
          message(total, objects)
        end
      end
    end
  end

  private

  # ------------ preload
  def spinner_layer(_color)
    content_tag :div, class: 'spinner-layer spinner-#{color}' do
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
