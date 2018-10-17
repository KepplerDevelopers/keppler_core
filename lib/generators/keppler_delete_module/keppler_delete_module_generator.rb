# frozen_string_literal: true

class KepplerDeleteModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  FILE_NAME = "#{ARGV[0].underscore.split('keppler_').last}"
  ROCKET_NAME = "keppler_#{FILE_NAME}"
  MODULE_NAME = ARGV[1].underscore
  ROCKET_DIRECTORY = "rockets/#{ROCKET_NAME}"

  ROCKET_CLASS_NAME = "#{ROCKET_NAME}".camelize
  MODULE_CLASS_NAME = MODULE_NAME.singularize.classify

  def create_module
    if ROCKET_NAME
      if MODULE_NAME
        if Dir.exist? ROCKET_DIRECTORY
          say "\n*** Creating #{MODULE_CLASS_NAME} module ***"
          remove_route
          remove_option_menu
          remove_option_permissions
          remove_locales
          remove_migrations
          if validate_rocket_scaffold
            say "\n***** RUNNING RAILS D SCAFFOLD *****\n"
            run_rails_d_scaffold
          else
            delete_model_file
            delete_policies_file
            delete_controller_file
            delete_views_files
          end
          migrate_database
          restart_server
          say "=== All Done. #{MODULE_NAME.classify} module has been created and installed ===\n", :green
        else
          say "\n!!! Error: Rocket doesn't exist !!!\n", :red
        end
      else
        say "\n!!! Error: Please insert module name !!!\n", :red
      end
    else
      say "\n!!! Error: Please insert rocket name !!!\n", :red
    end
  end

  private

  def remove_route
    return if options[:skip_routes]
    say "\n*** Removing routes ***"
    gsub_file(
      "#{ROCKET_DIRECTORY}/config/routes.rb", 
      "\n#{indent(str_route, 6)}", 
      ''
    )
    say "=== Routes has been removed ===\n", :green
  end

  def remove_option_menu
    say "\n*** Removing option in menu.yml ***"
    gsub_file(
      "#{ROCKET_DIRECTORY}/config/menu.yml",
      "\n#{indent(str_menu, 6)}",
      ''
    )
    say "=== Menu option has been removed ===\n", :green
  end

  def remove_option_permissions
    say "\n*** Removing option in permissions.yml ***"
    gsub_file(
      "#{ROCKET_DIRECTORY}/config/permissions.yml",
      "\n#{indent(str_permissions, 2)}",
      ''
    )
    say "=== Permission option has been removed ===\n", :green
  end

  def remove_locales
    %w[en es].each do |locale|
      %W[singularize pluralize modules #{ROCKET_NAME.dasherize}-submenu].each do |switch|
        say "\n*** Removing locale #{switch} from #{locale}.yml ***"
        remove_str_locales(locale, switch)
        say "=== Locale #{switch} has been removed from #{locale}.yml ===\n", :green
      end
    end
  end

  def remove_migrations
    removed_files = false
    say "\n*** Removing #{MODULE_NAME} migrations ***" unless removed_files
    Dir.glob("#{Rails.root}/db/migrate/*").each do |migration|
      if migration.include?(MODULE_NAME)
        say "=== Migration name: #{migration} ==="
        say "=== Table name: #{name_table(migration).to_sym}"
        if migration.include?('create')
          if ActiveRecord::Base.connection.table_exists? name_table(migration).to_sym
            if ActiveRecord::Migration.drop_table(name_table(migration).to_sym)
              say "--- #{name_table(migration)} table dropped ---", :green
            end
          end
        end
        if FileUtils.rm(migration)
          say "--- #{migration_name(migration)} migration file has been removed ---", :green
        end
        removed_files = true
      end
    end
    if removed_files
      say "=== #{MODULE_NAME.humanize} migrations has been removed ===", :green
    else
      say "\n... Doesn' t exist migrations with this rocket name. Skipping ..."
    end
  end

  # def table_name(migration)
  #   migration.split('/').last
  #     .split('.').first
  #     .remove('_create')
  #     .remove('_rename')
  #     .remove('_drop')
  #     .remove('_remove')
  #     .remove('_column')
  #     .remove('_from')
  #     .remove('_to')
  #     .split('_')
  #     .flatten[1..-1]
  #     .join('_')
  # end

  def run_rails_d_scaffold
    say "*** Entering to rockets/#{ROCKET_NAME} folder ***"
    FileUtils.cd ROCKET_DIRECTORY
    say "*** Running 'Rails d scaffold #{ROCKET_NAME}' ***"
    system "rails d keppler_scaffold #{MODULE_NAME.classify}"
    say "*** Coming back to Rails root folder ***"
    FileUtils.cd Rails.root
  end

  def delete_model_file
    say "\n*** Deleting #{MODULE_NAME.classify} model ***"
    model_path = "#{ROCKET_DIRECTORY}/app/models/#{ROCKET_NAME}/#{MODULE_NAME.singularize}.rb"
    File.delete(model_path) if File.exist?(model_path)
    say "=== #{MODULE_NAME.classify} model has been deleted ===\n", :green
  end

  def deleted_policies_file
    say "\n*** Deleting #{MODULE_NAME.classify} policy ***"
    policy_path = "#{ROCKET_DIRECTORY}/app/policies/#{ROCKET_NAME}/#{MODULE_NAME.singularize}_policy.rb"
    File.delete(policy_path) if File.exist?(policy_path)
    say "=== #{MODULE_NAME.classify} policy has been deletedd ===\n", :green
  end

  def delete_controller_file
    say "\n*** Deleting #{MODULE_NAME.pluralize.classify} controller ***"
    controller_path = "#{ROCKET_DIRECTORY}/app/controllers/#{ROCKET_NAME}/admin/#{MODULE_NAME.pluralize}_controller.rb"
    File.delete(controller_path) if File.exist?(controller_path)
    say "=== #{MODULE_NAME.pluralize.classify}Controller has been deleted ===\n", :green
  end

  def validate_rocket_scaffold
    File.exist? "#{ROCKET_DIRECTORY}/lib/generators/keppler_scaffold/keppler_scaffold_generator.rb"
  end

  def delete_views_files
    %w[
      _description _form _listing
      edit index new show
      reload.js
    ].each do |filename|
      delete_template_view("#{filename}.haml")
    end
  end

  # hook_for :test_framework, as: :scaffold

  # # Invoke the helper using the controller name (pluralized)
  # hook_for :helper, as: :scaffold do |invoked|
  #   invoke invoked, [controller_name]
  # end

    def migrate_database
      puts "\n*** Updating database ***"
      system 'bin/rails db:migrate'
      say "=== Database is updated ===\n", :green
    end

    def restart_server
      puts "\n*** Restarting application server ***"
      system 'bin/rails restart'
      system 'bin/rails restart'
      say "=== Application server has been restarted ===\n\n", :green
    end

  protected

  def remove_str_locales(locale, switch)
    gsub_file(
      "#{ROCKET_DIRECTORY}/config/locales/#{locale}.yml",
      "\n#{str_locales(switch)}",
      ''
    )
  end

  def str_route
    <<~HEREDOC
      resources :#{MODULE_NAME.pluralize} do
        post '/sort', action: :sort, on: :collection
        get '(page/:page)', action: :index, on: :collection, as: ''
        get '/clone', action: 'clone'
        post '/upload', action: 'upload', as: :upload
        get '/reload', action: :reload, on: :collection
        delete '/destroy_multiple', action: :destroy_multiple, on: :collection
      end
    HEREDOC
  end

  def str_menu
    <<~HEREDOC
      - #{MODULE_NAME.singularize}:
          name: #{MODULE_NAME.humanize.downcase}
          url_path: /admin/#{ROCKET_NAME.split('keppler_').last}/#{MODULE_NAME.pluralize}
          icon: layers
          current: ['/admin/#{ROCKET_NAME.split('keppler_').last}/#{MODULE_NAME.pluralize}']
          model: #{ROCKET_CLASS_NAME}::#{MODULE_CLASS_NAME}
    HEREDOC
  end

  def str_permissions
    <<~HEREDOC
    #{MODULE_NAME.pluralize}:
      name: #{MODULE_CLASS_NAME}
      model: #{ROCKET_CLASS_NAME}#{MODULE_CLASS_NAME}
      actions: [
        'index', 'create', 'update', 'destroy', 'download', 'upload', 'clone'
      ]
    HEREDOC
  end

  def str_locales(switch)
    case switch
    when "#{ROCKET_NAME.dasherize}-submenu"
      "        #{MODULE_NAME.dasherize}: #{MODULE_NAME.humanize}"
    when 'singularize'
      "        #{MODULE_NAME.singularize}: #{MODULE_NAME.singularize.humanize.downcase}"
    when 'pluralize'
      "        #{MODULE_NAME.pluralize}: #{MODULE_NAME.pluralize.humanize.downcase}"
    when 'modules'
      "      admin/#{MODULE_NAME.dasherize}: #{MODULE_NAME.humanize}"
    end
  end

  def delete_template_view(name_file)
    say "*** Removing #{name_file} ***"
    view_path = "#{ROCKET_DIRECTORY}/app/views/#{ROCKET_NAME}/admin/#{MODULE_NAME}/#{name_file}"
    File.delete(view_path) if File.exist?(view_path)
  end

  def arr_exist(path, search)
    object = []
    open(path).each do |line|
      object << line if line.to_s.include? search
    end
    object
  end

  def destination_path(path)
    File.join(destination_root, path)
  end

  def gsub_file(relative_destination, regexp, *args, &block)
    path = destination_path(relative_destination)
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, 'wb') do |file|
      file.write(content)
    end
  end

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

  def name_table(migration)
    migration
      .split('/')
      .last
      .split('.')
      .first
      .remove('_create')
      .split('_')
      .flatten[1..-1]
      .join('_')
      .pluralize
  end
end
