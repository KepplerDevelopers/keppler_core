# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# disabled field_with_error
ActionView::Base.field_error_proc = proc do |html_tag, _|
  html_tag.html_safe
end
