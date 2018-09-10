  class InstallRocketGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('templates', __dir__)

    def install_rocket
      rocket_directory = "#{Rails.root}/rockets/#{file_name}"
      if File.directory?(rocket_directory)
        add_route_line
        add_gem_line(rocket_directory)
        add_helper_in_application_core
        # add_helper_in_application_core
        # bundle_install
        migrate_database if copy_migrations_files
        run_rocket_generator
        # clear_temps_and_logs
        restart_server
      else
        say "!!! ERROR: #{class_name} Rocket doesn't exist !!!\n", :red
      end
    end

    private

    def add_gem_line(rocket_directory)
      if File.directory?(rocket_directory)
        puts "\n*** Adding #{file_name} gem to Gemfile ***"
        if append_to_file 'Gemfile', "\ngem '#{file_name}', path: 'rockets/#{file_name}'"
          say "=== #{class_name}'s gem added to Gemfile ===\n", :green
        else
          say "!!! Failed adding #{class_name} gem into Gemfile !!!"
        end
      else
        say "!!! Cannot add #{class_name} gem to Gemfile. Rocket doesn't exist !!!\n", :red
      end
    end

    def add_route_line
      if File.file?("#{Rails.root}/rockets/#{file_name}/config/routes.rb")
        puts "\n*** Adding #{class_name} route to config/routes ***"
        inject_into_file 'config/routes.rb', after: "mount Ckeditor::Engine => '/ckeditor'\n" do
          "\n  # #{class_name} routes engine\n  mount #{class_name}::Engine, at: '/', as: '#{file_name}'\n"
        end
        say "=== #{class_name}'s route added to config/routes ===\n", :green
      else
        say "\n... #{class_name} doesn't have routes. Skipping ...\n"
      end
    end

    def add_helper_in_application_core
      say "\n*** Copying #{class_name}'s helpers ***"
      inject_into_file 'app/controllers/application_controller.rb', after: "include PublicActivity::StoreController" do
        "\n  helper #{class_name}::ApplicationHelper"
      end
      say "=== #{class_name}'s helpers has been copied ===", :green
    end

    def copy_migrations_files
      rocket_migrations = "#{Rails.root}/rockets/#{file_name}/db/migrate"
      if File.directory?(rocket_migrations)
        puts "\n*** Copying migrations ***"
        # FileUtils.cp_r(Dir[rocket_migrations+'/*.*'], "#{Rails.root}/db/migrate/")
        system "rake #{file_name}:install:migrations"
        say "=== #{class_name} migrations has been copied ===\n", :green
        true
      else
        say "\n... #{class_name} doesn't have migrations in db. Skipping ...\n"
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
      say "=== Database is updated ===\n", :green
    end

    def run_rocket_generator
      rocket_additional = "#{Rails.root}/rockets/#{file_name}/lib/generators/install"
      if File.directory?(rocket_additional)
        puts "\n*** Running #{class_name} additional generator ***"
        FileUtils.cd("rockets/#{file_name}") do   # chdir
          system 'rails g install'                # do something
        end                                       # return to original directory
        say "=== Additional #{class_name} generator has been executed ===\n", :green
      else
        say "\n... #{class_name} doesn't have a custom installer. Skipping ...\n"
      end
    end

    def clear_temps_and_logs
      puts "\n*** Removing old logs and tempfiles ***"
      system 'bin/rails log:clear tmp:clear'
      say "=== Old logs and tempfiles has been removed ===\n", :green
    end

    def restart_server
      puts "\n*** Restarting application server ***"
      system 'bin/rails restart'
      system 'bin/rails restart'
      say "=== Application server has been restarted ===\n\n", :green
    end
  end
