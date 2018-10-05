class NewRocketGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  ROCKET_NAME = "keppler_#{ARGV[0].underscore.split('keppler_').last}"
  ROCKET_DIRECTORY = "#{Rails.root}/rockets/#{ROCKET_NAME}"
  ROCKET_CLASS_NAME = "#{ROCKET_NAME}".camelize

  def create_rocket
    if Dir.exists? ROCKET_DIRECTORY
      say "\n... Aborting. This Rocket already exists ...\n", :red
    else
      generate_rocket
      copy_layouts
      copy_generator
      add_helper_in_application_core
      add_head_in_application_rocket
      create_policies_folder
      add_locales
      add_route_line
      restart_server
      say "\n=== All Done. #{class_name} Rocket has been created and installed ===\n", :green
    end
  end

  private

  def generate_rocket
    say "\n*** Generating rocket ***\n"

    system("rails plugin new rockets/#{ROCKET_NAME} --mountable -f")
    say "=== #{class_name} Rocket has been generated ===\n", :green

    say "\n*** Replacing 'TODO' by 'https://keppleradmin.com' in #{class_name} gemspec ***\n"

    gemspec = "rockets/#{ROCKET_NAME}/#{ROCKET_NAME}.gemspec"
    path = File.join(Rails.root, gemspec)
    content = File.read(path).gsub(/TODO/, 'https://keppleradmin.com')
    if File.open(path, 'wb') { |file| file.write(content) }
      say "=== 'TODO' words has been replaced in gemspec ===\n", :green
    else
      say "!!! 'TODO' words could not be replaced in gemspec !!!", :red
    end
  end

  def add_route_line
    # if File.file?("#{Rails.root}/rockets/#{ROCKET_NAME}/config/routes.rb")
    puts "\n*** Adding #{ROCKET_CLASS_NAME} route to config/routes ***"
    inject_into_file 'config/routes.rb', after: "mount Ckeditor::Engine => '/ckeditor'\n" do
      "\n  # #{class_name} routes engine\n  mount #{ROCKET_CLASS_NAME}::Engine, at: '/', as: '#{file_name}'\n"
    end
    say "=== #{ROCKET_CLASS_NAME}'s route added to config/routes ===\n", :green
    # else
    #   say "\n... #{ROCKET_CLASS_NAME} doesn't have routes. Skipping ...\n"
    # end
  end

  def copy_generator
    say "\n*** Copying generators from Core to Rocket ***\n"

    if directory "#{Rails.root}/lib/plugins/generators", "#{Rails.root}/rockets/#{ROCKET_NAME}/lib/generators"
      say "=== Generators has been copied from Core to #{class_name} Rocket ===/n", :green
    else
      say "!!! Generators could not be copied. Please check if /lib/plugins exists !!!/n", :red
    end
  end

  def copy_layouts
    say "\n*** Copying Layouts from Core to Rocket ***\n"

    if FileUtils.mkdir_p "#{Rails.root}/rockets/#{ROCKET_NAME}/app/views/#{ROCKET_NAME}/admin/layouts"
      say "=== #{class_name} Layouts folder has been created ===\n", :green
    else
      say  "!!! #{class_name} Layouts folder could not be created. Please check if /rockets/#{ROCKET_NAME} exists !!!\n", :red
    end

    if directory "#{Rails.root}/lib/plugins/layouts", "#{Rails.root}/rockets/#{ROCKET_NAME}/app/views/#{ROCKET_NAME}/admin/layouts"
      say "=== Layouts has been copied from Core to #{class_name} Rocket ===/n", :green
    else
      say "!!! Layouts could not be copied. Please check if /lib/plugins exists !!!/n", :red
    end

    # system("ruby #{Rails.root}/lib/plugins/install.rb #{ROCKET_NAME} #{Rails.root}")
    install
  end

  def add_locales
    %w[en es].each do |locale|
      %W[sidebar-menu].each do |switch|
        say "\n*** Adding locale #{switch} in #{locale}.yml ***"
        add_str_locales(locale, switch)
        say "=== Locale #{switch} has been added in #{locale}.yml ===\n", :green
      end
    end
  end

  def add_helper_in_application_core
    say "\n*** Copying #{class_name}'s helpers ***"
    inject_into_file 'app/controllers/application_controller.rb', after: "include PublicActivity::StoreController" do
      "\n  helper Keppler#{class_name}::ApplicationHelper"
    end
    say "=== #{class_name}'s helpers has been copied ===", :green
  end

  def add_head_in_application_rocket
    head = "#{ROCKET_DIRECTORY}/app/views/#{ROCKET_NAME}/admin/layouts/_head.haml"
    say "\n*** Creating #{class_name}'s head ***"
    FileUtils.touch head
    File.open(head, "w+") do |f|
      f.write("// #{class_name} Stylesheets\n= stylesheet_link_tag '#{ROCKET_NAME}/application', media: 'all', 'data-turbolinks-track': true\n// #{class_name} Javascripts\n= javascript_include_tag '#{ROCKET_NAME}/application', 'data-turbolinks-track': true")
    end
    say "=== #{class_name}'s head has been created ===", :green
    say "\n*** Adding #{class_name}'s head in its application.haml ***"
    inject_into_file "#{ROCKET_DIRECTORY}/app/views/#{ROCKET_NAME}/admin/layouts/application.html.haml", after: "= render 'admin/layouts/head'" do
      "\n  = render '#{ROCKET_NAME}/admin/layouts/head'"
    end
    say "=== #{class_name}'s head has been added ===", :green
  end

  def create_policies_folder
    say "\n*** Creating Policies folder in /rockets/#{ROCKET_NAME}/app/policies ***\n"

    if FileUtils.mkdir_p "#{Rails.root}/rockets/#{ROCKET_NAME}/app/policies"
      say "=== #{class_name} Policies folder has been created ===\n", :green
    else
      say  "!!! #{class_name} Policies folder could not be created. Please check if /rockets/#{ROCKET_NAME} exists !!!\n", :red
    end
  end

  def restart_server
    say "\n*** Restarting application server ***"
    system 'bin/rails restart'
    system 'bin/rails restart'
    say "=== Application server has been restarted ===\n", :green
  end

  protected

  def add_str_locales(locale, switch)
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/locales/#{locale}.yml",
      "\n#{str_locales(switch)}",
      after: "#{switch}:"
    )
  end

  def str_locales(switch)
    case switch
    when 'sidebar-menu'
      "      #{ROCKET_NAME.dasherize}: #{ROCKET_NAME.humanize}\n      #{ROCKET_NAME.dasherize}-submenu:"
    end
  end

  def install
    gemspec
    engine
    route
    menu_permissions_locales
    application
    dummy_test
  end

  def gemspec
    gemspec = File.readlines("#{Rails.root}/rockets/#{ROCKET_NAME}/#{ROCKET_NAME}.gemspec")

    gemspec[11] = "  s.homepage    = 'http://keppleradmin.com'\n"
    gemspec[12] = "  s.summary     = '#{ROCKET_NAME}'\n"
    gemspec[13] = "  s.description = '#{ROCKET_NAME}'\n"

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

    File.write("#{Rails.root}/rockets/#{ROCKET_NAME}/#{ROCKET_NAME}.gemspec", gemspec)
  end

  def engine
    engine = File.readlines("#{Rails.root}/rockets/#{ROCKET_NAME}/lib/#{ROCKET_NAME}/engine.rb")

    engine.insert(3, "    paths['config/locales']\n")
    engine.insert(4, "    config.generators do |g|\n")
    engine.insert(5, "      g.template_engine :haml\n")
    engine.insert(6, "    end\n")
    engine.insert(7, "\n")
    engine.insert(8, "    config.to_prepare do\n")
    engine.insert(9, "      ApplicationController.helper(ApplicationHelper)\n")
    engine.insert(10, "    end\n")

    engine = engine.join("")

    File.write("#{Rails.root}/rockets/#{ROCKET_NAME}/lib/#{ROCKET_NAME}/engine.rb", engine)
  end

  def route
    route = File.readlines("#{Rails.root}/rockets/#{ROCKET_NAME}/config/routes.rb")

    route.insert(1, "  namespace :admin do\n")
    route.insert(2, "    scope :#{ROCKET_NAME.split('_').drop(1).join('_')}, as: :#{ROCKET_NAME.split('_').drop(1).join('_')} do\n")
    route.insert(3, "    end\n")
    route.insert(4, "  end\n")

    route = route.join("")

    File.write("#{Rails.root}/rockets/#{ROCKET_NAME}/config/routes.rb", route)
  end

  def menu_permissions_locales
    system("scp -r #{Rails.root}/lib/plugins/config/permissions.yml #{Rails.root}/rockets/#{ROCKET_NAME}/config/permissions.yml")

    system("scp -r #{Rails.root}/lib/plugins/config/menu.yml #{Rails.root}/rockets/#{ROCKET_NAME}/config/menu.yml")

    menu = File.readlines("#{Rails.root}/rockets/#{ROCKET_NAME}/config/menu.yml")

    menu[1] = "  #{ROCKET_NAME}:\n"
    menu[2] = "    name: #{ROCKET_NAME.split('_').map(&:capitalize).join(' ')}\n"

    menu = menu.join("")

    File.write("#{Rails.root}/rockets/#{ROCKET_NAME}/config/menu.yml", menu)

    system("scp -r #{Rails.root}/lib/plugins/config/locales #{Rails.root}/rockets/#{ROCKET_NAME}/config/locales")
  end

  def application
    system("scp -r #{Rails.root}/lib/plugins/concerns #{Rails.root}/rockets/#{ROCKET_NAME}/app/controllers/#{ROCKET_NAME}")

    application = File.readlines("#{Rails.root}/rockets/#{ROCKET_NAME}/app/controllers/#{ROCKET_NAME}/application_controller.rb")

    application[1] = "  class ApplicationController < ::ApplicationController\n"

    application.insert(3, "    before_action :user_signed_in?\n")
    application.insert(4, "    def user_signed_in?\n")
    application.insert(5, "      return if current_user\n")
    application.insert(6, "      redirect_to main_app.new_user_session_path\n")
    application.insert(7, "    end\n")

    application = application.join("")

    File.write("#{Rails.root}/rockets/#{ROCKET_NAME}/app/controllers/#{ROCKET_NAME}/application_controller.rb", application)
  end

  def dummy_test
    dummy_test = File.readlines("#{Rails.root}/rockets/#{ROCKET_NAME}/test/dummy/config/database.yml")

    dummy_test[7] = "  adapter: postgresql\n"
    dummy_test = dummy_test.join("")

    File.write("#{Rails.root}/rockets/#{ROCKET_NAME}/test/dummy/config/database.yml", dummy_test)
  end
end
