class InstallRocketGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def install_rocket
    rocket_directory = "#{Rails.root}/rockets/#{file_name}"
    if File.directory?(rocket_directory)
      add_gem_line
      add_route_line
      bundle_install
      copy_migrations_files
      migrate_database
      clear_temps_and_logs
      restart_server
      run_rocket_generator
    else
      say "!!! ERROR: Rocket doesn't exist !!!\n", :red
    end
  end

  private

  def copy_migrations_files
    rocket_migrations = "#{Rails.root}/rockets/#{file_name}/db/migrate"
    if File.directory?(rocket_migrations)
      puts "\n*** Copying migrations ***"
      # FileUtils.cp_r(Dir[rocket_migrations+'/*.*'], "#{Rails.root}/db/migrate/")
      system "rake #{file_name}:install:migrations"
      say "=== #{class_name} migrations has been copied ===\n", :green
      true
    else
      say "!!! Cannot copy #{class_name} migrations. Directory doesn't exist !!!\n", :red
      false
    end
  end

  def add_gem_line
    rocket_directory = "#{Rails.root}/rockets/#{file_name}"
    if File.directory?(rocket_directory)
      puts "\n*** Adding gems to Gemfile ***"
      append_to_file 'Gemfile' do
        "gem '#{file_name}', path: 'rockets/#{file_name}'\n"
      end
      say "=== #{class_name}'s gem added to Gemfile ===\n", :green
      true
    else
      say "!!! Cannot add #{class_name} gem to Gemfile. Rocket doesn't exist !!!\n", :red
      false
    end
  end

  def add_route_line
    rocket_directory = "#{Rails.root}/rockets/#{file_name}/config"
    if File.directory?(rocket_directory)
      puts "\n*** Adding #{class_name} route to config/routes ***"
      inject_into_file 'config/routes.rb', after: "mount Ckeditor::Engine => '/ckeditor'\n" do
        "\n\t# #{class_name} routes engine\n\tmount #{class_name}::Engine, at: '/', as: '#{file_name}'\n"
      end
      # inject_into_class "config/routes.rb", Rails do
      #   "\n\t# #{class_name} routes engine\n\tmount #{class_name}::Engine, at: '/', as: '#{file_name}'\n"
      # end
      say "=== #{class_name}'s route added to config/routes ===\n", :green
      true
    else
      say "!!! Cannot add #{class_name} route to config/routes. Rocket doesn't exist !!!\n", :red
      false
    end
  end

  def bundle_install
    puts "\n*** Installing #{class_name} ***"
    system('bundle check') || system('bundle install')
    say "=== Bundle list is updated ===", :green
  end

  def migrate_database
    puts "\n*** Updating database ***"
    system 'bin/rails db:migrate'
    say "=== Database has been updated ===\n", :green
  end

  def clear_temps_and_logs
    puts "\n*** Removing old logs and tempfiles ***"
    system 'bin/rails log:clear tmp:clear'
    say "=== Old logs and tempfiles has been removed ===\n", :green
  end

  def restart_server
    puts "\n*** Restarting application server ***"
    system 'bin/rails restart'
    say "=== Application server has been restarted ===\n", :green
  end

  def run_rocket_generator
    rocket_additional = "#{Rails.root}/rockets/#{file_name}/lib/generators/install"
    if File.directory?(rocket_additional)
      puts "\n*** Running #{class_name} additional generator ***"
      FileUtils.cd("rockets/#{file_name}") do   # chdir
        system 'rails g install'                # do something
      end                                       # return to original directory
      say "=== Additional #{class_name} generator has been executed ===\n", :green
    # else
    #   say "!!! Rocket custom generator doesn't exist !!!\n", :red
    end
  end
end
