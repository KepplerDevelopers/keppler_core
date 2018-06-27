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
end
