# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :lumx do |b|
    b.use :html5
    b.wrapper :lx_text_field, tag: 'lx-text-field' do |ba|
      ba.use :input
    end
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  #config.default_wrapper = :lumx
end