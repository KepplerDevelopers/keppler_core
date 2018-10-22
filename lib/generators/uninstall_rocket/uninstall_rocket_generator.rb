class UninstallRocketGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def uninstall_rocket
    remove_rocket_directory
    remove_rocket_built
    remove_migrations
    remove_route_line
    remove_gem_line
    remove_helper_from_core_application
    # bundle_install
    # clear_temps_and_logs
    restart_server
  end

  private

  def remove_rocket_directory
    rocket_directory = "#{Rails.root}/rockets/#{file_name}"
    if File.directory?(rocket_directory)
      say "\n*** Removing #{class_name} directory ***"
      if FileUtils.rm_rf rocket_directory
        say "=== #{class_name} directory removed ===", :green
      else
        say "!!! Error: Cannot remove #{class_name} rocket directory !!!", :red
      end
    else
      say "\n... #{class_name} doesn't have a rocket directory. Skipping ..."
    end
  end

  def remove_rocket_built
    rocket_built = "#{Rails.root}/public/rockets/#{file_name}.rocket"
    if File.file?(rocket_built)
      say "\n*** Removing #{class_name} rocket built ***"
      if FileUtils.rm rocket_built
        say "=== #{class_name} rocket built removed ===", :green
      else
        say "!!! Error: Cannot remove #{class_name} rocket built !!!", :red
      end
    else
      say "\n... #{class_name} doesn't have a rocket built. Skipping ..."
    end
  end

  def remove_migrations
    removed_files = false
    Dir.glob('db/migrate/*').each do |migration|
      if migration.include?(file_name)
        say "\n*** Removing #{class_name} migrations ***" unless removed_files
        if ActiveRecord::Base.connection.table_exists? table_name(migration).to_sym
          if migration.include?('create')
            if ActiveRecord::Migration.drop_table(table_name(migration).to_sym)
              say "--- #{table_name(migration)} table dropped ---"
            end
          end
        end
        if FileUtils.rm migration
          say "--- #{migration_name(migration)} migration file has been removed ---"
        end
        removed_files = true
      end
    end
    if removed_files
      say "=== #{class_name} migrations has been removed ===", :green
    else
      say "\n... Doesn' t exist migrations with this rocket name. Skipping ..."
    end
  end

  def remove_gem_line
    say "\n*** Removing #{class_name} gem from Gemfile ***"
    gsub_file 'Gemfile', "\ngem '#{file_name}', path: 'rockets/#{file_name}'", ""
    say "=== #{class_name} gem removed from Gemfile ===\n", :green
  end

  def remove_route_line
    say "\n*** Removing #{class_name} routes from config/routes ***"
    gsub_file 'config/routes.rb', "\n\n  # #{file_name.remove('keppler_').camelize} routes engine\n  mount #{class_name}::Engine, at: '/', as: '#{file_name.remove('keppler_')}'", ""
    say "=== #{class_name} route removed from config/routes.rb ===\n", :green
  end

  def remove_helper_from_core_application
    say "\n*** Removing #{class_name} helpers from core/application_controller.rb ***"
    gsub_file "app/controllers/application_controller.rb", "\n  helper #{class_name}::ApplicationHelper", ""
    say "=== #{class_name} helpers removed from core/application_controller.rb ===\n", :green
  end

  def bundle_install
    say "\n*** Uninstalling #{class_name} ***"
    system('bundle check') || system('bundle install')
    say "=== Bundle list is updated ===", :green
  end

  def clear_temps_and_logs
    say "\n*** Removing old logs and tempfiles ***"
    system 'bin/rails log:clear tmp:clear'
    say "=== Old logs and tempfiles has been removed ===\n", :green
  end

  def restart_server
    say "\n*** Restarting application server ***"
    system 'bin/rails restart'
    system 'bin/rails restart'
    say "=== Application server has been restarted ===\n", :green
  end

  protected

  def migration_name(migration)
    migration.split('/').last
      .split('.').first
      .split('_')[1..-1]
      .join('_').camelize
  end

  def migration_num(migration)
    migration.split('/').last
      .split('.').first
      .split('_').first
  end

  def table_name(migration)
    migration.split('/').last
      .split('.').first
      .split('create')
      .split('rename')
      .split('drop')
      .split('remove')
      .split('column')
      .split('from')
      .split('to')
      .split('_')
      .split(' ')
      .join('')
      .split('_')
      .split('').flatten[1..-1]
      .join('_')
  end
end
