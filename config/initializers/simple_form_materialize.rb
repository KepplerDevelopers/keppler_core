# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :materialize, tag: 'div', class: 'input-field col s12', :error_class => 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :input, class: "validate"
    b.use :label
    b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
  end

  1.upto(12) do |col|
    config.wrappers "mf_#{col}".to_sym, tag: 'div', class: "input-field col s#{col}", :error_class => 'error' do |b|
      b.use :html5
      b.use :placeholder
      b.use :input, class: "validate"
      b.use :label
      b.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
      b.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :materialize
end