class NewRocketGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  ROCKET_NAME = "keppler_#{ARGV[0].underscore.split('keppler_').last}"
  ROCKET_DIRECTORY = "#{Rails.root}/rockets/#{ROCKET_NAME}"

  def create_rocket
    if Dir.exists? ROCKET_DIRECTORY
      say "\n... Aborting. This Rocket already exists ...\n", :red
    else
      generate_rocket
      copy_generator
      copy_layouts
      add_locales
      add_helper_in_application_core
      add_head_in_application_rocket
      create_policies_folder
      restart_server
      say "\n=== All Done. #{class_name} Rocket has been created and installed ===\n", :green
    end
  end

  private

  def generate_rocket
    say "\n*** Generating rocket ***\n"

    system("rails plugin new rockets/#{ROCKET_NAME} --mountable")
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

    system("ruby #{Rails.root}/lib/plugins/install.rb #{ROCKET_NAME} #{Rails.root}")
  end

  def add_locales
    %w[en es].each do |locale|
      %w[sidebar-menu].each do |switch|
        say "\n*** Adding locale #{switch} in #{locale}.yml ***"
        add_str_locales(locale, switch)
        say "=== Locale #{switch} has been added in #{locale}.yml", :green
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
end
