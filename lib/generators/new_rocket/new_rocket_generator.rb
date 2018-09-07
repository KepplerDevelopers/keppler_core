class NewRocketGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def create_rocket
    rocket_name = file_name.split('keppler_').last
    if Dir.exists? "#{Rails.root}/rockets/keppler_#{rocket_name}"
      say "\n... Aborting. This Rocket already exists ...\n", :red
    else
      generate_rocket(rocket_name)
      copy_generator(rocket_name)
      copy_layouts(rocket_name)
      add_helper_in_application_core
      create_policies_folder(rocket_name)
      say "\n=== All Done. #{class_name} Rocket has been created and installed ===\n", :green
    end
  end

  private

  def generate_rocket(rocket_name)
    say "\n*** Generating rocket ***\n"

    system("rails plugin new rockets/keppler_#{rocket_name} --mountable")
    say "=== #{class_name} Rocket has been generated ===\n", :green

    say "\n*** Replacing 'TODO' by 'https://keppleradmin.com' in #{class_name} gemspec ***\n"

    gemspec = "rockets/keppler_#{rocket_name}/keppler_#{rocket_name}.gemspec"
    path = File.join(Rails.root, gemspec)
    content = File.read(path).gsub(/TODO/, 'https://keppleradmin.com')
    if File.open(path, 'wb') { |file| file.write(content) }
      say "=== 'TODO' words has been replaced in gemspec ===\n", :green
    else
      say "!!! 'TODO' words could not be replaced in gemspec !!!", :red
    end
  end

  def copy_generator(rocket_name)
    say "\n*** Copying generators from Core to Rocket ***\n"

    if directory "#{Rails.root}/lib/plugins/generators", "#{Rails.root}/rockets/keppler_#{rocket_name}/lib/generators"
      say "=== Generators has been copied from Core to #{class_name} Rocket ===/n", :green
    else
      say "!!! Generators could not be copied. Please check if /lib/plugins exists !!!/n", :red
    end
  end

  def copy_layouts(rocket_name)
    say "\n*** Copying Layouts from Core to Rocket ***\n"

    if FileUtils.mkdir_p "#{Rails.root}/rockets/keppler_#{rocket_name}/app/views/keppler_#{rocket_name}/admin/layouts"
      say "=== #{class_name} Layouts folder has been created ===\n", :green
    else
      say  "!!! #{class_name} Layouts folder could not be created. Please check if /rockets/keppler_#{rocket_name} exists !!!\n", :red
    end

    if directory "#{Rails.root}/lib/plugins/layouts", "#{Rails.root}/rockets/keppler_#{rocket_name}/app/views/keppler_#{rocket_name}/admin/layouts"
      say "=== Layouts has been copied from Core to #{class_name} Rocket ===/n", :green
    else
      say "!!! Layouts could not be copied. Please check if /lib/plugins exists !!!/n", :red
    end

    system("ruby #{Rails.root}/lib/plugins/install.rb keppler_#{rocket_name} #{Rails.root}")
  end

  def add_helper_in_application_core
    say "*** Copying #{class_name}'s helpers ***"
    inject_into_file 'app/controllers/application_controller.rb', after: "include PublicActivity::StoreController" do
      "  helper Keppler#{file_name.classify}::ApplicationHelper"
    end
    say "=== #{class_name}'s helpers has been copied ===", :green
  end

  def create_policies_folder(rocket_name)
    say "\n*** Creating Policies folder in /rockets/#{file_name}/app/policies ***\n"

    if FileUtils.mkdir_p "#{Rails.root}/rockets/keppler_#{rocket_name}/app/policies"
      say "=== #{class_name} Policies folder has been created ===\n", :green
    else
      say  "!!! #{class_name} Policies folder could not be created. Please check if /rockets/keppler_#{rocket_name} exists !!!\n", :red
    end
  end
end
