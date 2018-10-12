gemspec = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/#{ARGV[0]}.gemspec")

gemspec[11] = "  s.homepage    = 'http://keppleradmin.com'\n"
gemspec[12] = "  s.summary     = '#{ARGV[0]}'\n"
gemspec[13] = "  s.description = '#{ARGV[0]}'\n"

gemspec.insert(17, "  s.test_files = Dir['test/**/*']\n")

# gemspec.delete_at(19)
# gemspec.delete_at(20)

gemspec[19] = "  s.add_dependency 'rails', '5.2.0'\n"
gemspec[20] = "  s.add_dependency 'simple_form'\n"
gemspec.insert(21, "  s.add_dependency 'haml_rails'\n")
gemspec.insert(22, "  s.add_dependency 'pundit'\n")
gemspec.insert(23, "  s.add_development_dependency 'pg'\n")
gemspec.delete_at(24)
gemspec = gemspec.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/#{ARGV[0]}.gemspec", gemspec)

engine = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/lib/#{ARGV[0]}/engine.rb")

engine.insert(3, "    paths['config/locales']\n")
engine.insert(4, "    config.generators do |g|\n")
engine.insert(5, "      g.template_engine :haml\n")
engine.insert(6, "    end\n")
engine.insert(7, "\n")
engine.insert(8, "    config.to_prepare do\n")
engine.insert(9, "      ApplicationController.helper(ApplicationHelper)\n")
engine.insert(10, "    end\n")

engine = engine.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/lib/#{ARGV[0]}/engine.rb", engine)

route = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/config/routes.rb")

route.insert(1, "  namespace :admin do\n")
route.insert(2, "    scope :#{ARGV[0].split('_').drop(1).join('_')}, as: :#{ARGV[0].split('_').drop(1).join('_')} do\n")
route.insert(3, "    end\n")
route.insert(4, "  end\n")

route = route.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/config/routes.rb", route)

system("scp -r #{ARGV[1]}/lib/plugins/config/permissions.yml #{ARGV[1]}/rockets/#{ARGV[0]}/config/permissions.yml")

system("scp -r #{ARGV[1]}/lib/plugins/config/menu.yml #{ARGV[1]}/rockets/#{ARGV[0]}/config/menu.yml")

menu = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/config/menu.yml")

menu[1] = "  #{ARGV[0]}:\n"
menu[2] = "    name: #{ARGV[0].split('_').map(&:capitalize).join(' ')}\n"

menu = menu.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/config/menu.yml", menu)

system("scp -r #{ARGV[1]}/lib/plugins/config/locales #{ARGV[1]}/rockets/#{ARGV[0]}/config/locales")

project = ARGV[0].to_s

# locales = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/config/locales/en.yml")

# locales[2] = "    #{project.remove('keppler').gsub('_', '-')}:\n"
# locales[3] = "      #{project.gsub('_', '-')}: #{ARGV[0].split('_').map(&:capitalize).join(' ')}\n"
# locales[4] = "      #{project.gsub('_', '-')}-submenu:\n"

# locales = locales.join("")

# File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/config/locales/en.yml", locales)

# locales = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/config/locales/es.yml")

# locales[3] = "      #{project.gsub('_', '-')}: #{ARGV[0].split('_').map(&:capitalize).join(' ')}\n"
# locales[4] = "      #{project.gsub('_', '-')}-submenu:\n"

# locales = locales.join("")

# File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/config/locales/es.yml", locales)


system("scp -r #{ARGV[1]}/lib/plugins/concerns #{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}")

commons = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/concerns/commons.rb")

commons[0] = "module #{ARGV[0].split('_').map(&:capitalize).join('')}\n"

commons = commons.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/concerns/commons.rb", commons)


destroy = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/concerns/destroy_multiple.rb")

destroy[0] = "module #{ARGV[0].split('_').map(&:capitalize).join('')}\n"

destroy = destroy.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/concerns/destroy_multiple.rb", destroy)

history = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/concerns/history.rb")

history[0] = "module #{ARGV[0].split('_').map(&:capitalize).join('')}\n"

history = history.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/concerns/history.rb", history)

application = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/application_controller.rb")

application[1] = "  class ApplicationController < ::ApplicationController\n"

application = application.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/application_controller.rb", application)

dummy_test = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/test/dummy/config/database.yml")

dummy_test[7] = "  adapter: postgresql\n"
dummy_test = dummy_test.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/test/dummy/config/database.yml", dummy_test)

# generator_routes = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/lib/generators/keppler_scaffold/keppler_scaffold_generator.rb")

# generator_routes[37] = "          after: 'scope :#{ARGV[0].split('_').drop(1).join('')}, as: :#{ARGV[0].split('_').drop(1).join('')} do'\n"
# generator_routes = generator_routes.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/lib/generators/keppler_scaffold/keppler_scaffold_generator.rb", generator_routes)

layouts = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/app/views/#{ARGV[0]}/admin/layouts/application.html.haml")
layouts[7] = "        = render 'admin/layouts/navigation', q: @q, appearance: @appearance, model_obj: model_object.push(@q)\n"

layouts = layouts.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/app/views/#{ARGV[0]}/admin/layouts/application.html.haml", layouts)

application = File.readlines("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/application_controller.rb")

application.insert(3, "    before_action :user_signed_in?\n")
application.insert(4, "    def user_signed_in?\n")
application.insert(5, "      return if current_user\n")
application.insert(6, "      redirect_to main_app.new_user_session_path\n")
application.insert(7, "    end\n")

application = application.join("")

File.write("#{ARGV[1]}/rockets/#{ARGV[0]}/app/controllers/#{ARGV[0]}/application_controller.rb", application)
