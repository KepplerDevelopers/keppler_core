coffeescript_options = {
  input: 'app/assets/javascripts',
  output: 'app/assets/javascripts/guard_javascript',
  patterns: [%r{^app/assets/javascripts/(.+\.(?:coffee|coffee\.md|litcoffee))$}]
}

guard 'coffeescript', coffeescript_options do
  coffeescript_options[:patterns].each { |pattern| watch(pattern) }
end

#guard 'sass', :input => 'app/assets/stylesheets/frontend/native_stylesheets', :output => 'app/assets/stylesheets/frontend/native_stylesheets/guard_stylesheets'

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(sass|scss|css|js|coffee|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end
