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

  # Header information dinamic in keppler back-office
  def header_information(&block)
    content_for(:header_information) { capture(&block) }
  end

  # True if a user is logged
  def loggedin?
    current_user
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
    controller_name.classify.constantize
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

  private

  def action_convert_to_locale
    case action_name
    when 'create' then 'created'
    when 'update' then 'updated'
    when 'destroy' then 'deleted'
    when 'destroy_multiple' then 'removed'
    end
  end
end
