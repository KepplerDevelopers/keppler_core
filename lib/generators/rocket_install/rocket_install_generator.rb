class RocketInstallGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def copy_migrations_file
    FileUtils.cp_r(Dir["#{Rails.root}/rockets/#{file_name}/db/migrate/*.*"],"#{Rails.root}/db/migrate/")
  end

  def add_gem_line
    inject_into_file 'Gemfile', after: "# ----- Rockets ----- #\n" do
      "gem '#{file_name}', path: 'rockets/#{file_name}'\n"
    end
  end

  def add_route_line
    inject_into_file 'config/routes.rb', after: "mount Ckeditor::Engine => '/ckeditor'\n" do
      "\n\t# #{class_name} routes engine\n\tmount #{class_name}::Engine, at: '/', as: '#{file_name}'\n"
    end
  end

  def bundle_install
    puts "\n=== Installing #{class_name} ==="
    system('bundle check') || system('bundle install')
  end

  def migrate_database
    puts "\n=== Updating database ==="
    system 'bin/rails db:migrate'
  end

  def clear_temps_and_logs
    puts "\n=== Removing old logs and tempfiles ==="
    system 'bin/rails log:clear tmp:clear'
  end

  def restart_server
    puts "\n=== Restarting application server ==="
    system 'bin/rails restart'
  end

  def run_rocket_generator
    system "cd rockets/#{file_name}"
    system 'rails g install'
  end
end
