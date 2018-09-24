# frozen_string_literal: true

class KepplerModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  ROCKET_NAME = "keppler_#{ARGV[0].underscore.split('keppler_').last}"
  MODULE_NAME = ARGV[1].underscore
  ATTRIBUTES = ARGV[2] ? ARGV[2..20].map { |x| x.include?(':') ? x.split(':') : [x, 'string'] }.to_h : nil
  ATTRIBUTES_NAMES = ATTRIBUTES.keys
  ROCKET_DIRECTORY = "#{Rails.root}/rockets/#{ROCKET_NAME}"

  ROCKET_CLASS_NAME = "#{ROCKET_NAME}".camelize
  MODULE_CLASS_NAME = MODULE_NAME.singularize.classify

  NAMES = %w[name title first_name full_name]
  SINGULAR_ATTACHMENTS = %w[logo brand photo avatar cover image picture banner attachment pic file]
  PLURAL_ATTACHMENTS = SINGULAR_ATTACHMENTS.map(&:pluralize)
  SEARCHABLE_ATTRIBUTES = ATTRIBUTES.reject { |k,v| SINGULAR_ATTACHMENTS.include?(k) || PLURAL_ATTACHMENTS.include?(k) || v.eql?('jsonb') || v.eql?('references') }.map(&:first).join(' ')

  def create_module
    if ROCKET_NAME
      if MODULE_NAME
        if Dir.exist? ROCKET_DIRECTORY
          say "\n*** Creating #{MODULE_CLASS_NAME} module ***"
          add_route
          add_option_menu
          add_option_permissions
          add_locales
          remove_migrations
          create_model_file
          create_policies_file
          create_controller_file
          create_views_files
          migrate_database if create_migration_file
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

  def add_route
    return if options[:skip_routes]
    say "\n*** Adding routes ***"
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/routes.rb",
      "\n#{indent(str_route, 6)}",
      after: "scope :#{ROCKET_NAME}, as: :#{ROCKET_NAME} do"
    )
    say "=== Routes has been added ===\n", :green
  end

  def add_option_menu
    say "\n*** Adding option in menu.yml ***"
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/menu.yml",
      "\n#{indent(str_menu, 6)}",
      after: 'submenu:'
    )
    say "=== Menu option has been added ===\n", :green
  end

  def add_option_permissions
    say "\n*** Adding option in permissions.yml ***"
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/permissions.yml",
      "\n#{indent(str_permissions, 2)}",
      after: 'modules:'
    )
    say "=== Permission option has been added ===\n", :green
  end

  def add_locales
    %w[en es].each do |locale|
      %W[singularize pluralize modules #{ROCKET_NAME.dasherize}-submenu].each do |switch|
        say "\n*** Adding locale #{switch} in #{locale}.yml ***"
        add_str_locales(locale, switch)
        say "=== Locale #{switch} has been added in #{locale}.yml ===\n", :green
      end
    end
  end

  def remove_migrations
    removed_files = false
    Dir.glob("#{Rails.root}/db/migrate/*").each do |migration|
      if migration.include?(MODULE_NAME)
        say "\n*** Removing #{MODULE_NAME} migrations ***" unless removed_files
        if ActiveRecord::Base.connection.table_exists? name_table(migration).to_sym
          if migration.include?('create')
            if ActiveRecord::Migration.drop_table(name_table(migration).to_sym)
              say "--- #{name_table(migration)} table dropped ---"
            end
          end
        end
        say migration
        if FileUtils.rm(migration) && FileUtils.rm("#{ROCKET_DIRECTORY}/db/migrate/#{migration.split('/').last.split('.').first}.rb")
          say "--- #{migration_name(migration)} migration file has been removed ---"
        end
        removed_files = true
      end
    end
    if removed_files
      say "=== #{MODULE_NAME} migrations has been removed ===", :green
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

  def create_migration_file
    say "*** Entering to Rocket Directory ***"
    FileUtils.cd ROCKET_DIRECTORY
    say "*** Running 'rails g migration #{MODULE_NAME.classify} #{ATTRIBUTES.map { |x| "#{x.first}:#{x.last}" }.join(' ') }' ***"
    system "rails g migration create_#{MODULE_NAME.pluralize} #{ATTRIBUTES.map { |x| "#{x.first}:#{x.last}" }.join(' ') }"
    say "*** Exiting from Rocket Directory ***"
    FileUtils.cd Rails.root
    say "*** Importing migrations from #{ROCKET_NAME}/db ***"
    system "rake #{ROCKET_NAME}:install:migrations"
    say "=== Migration has been created ===\n", :green
  end

  def create_model_file
    say "\n*** Creating #{MODULE_NAME.classify} model ***"
    model_path = "#{ROCKET_DIRECTORY}/app/models/#{ROCKET_NAME}/#{MODULE_NAME.singularize}.rb"
    File.delete(model_path) if File.exist?(model_path)
    template("models/model.rb", model_path)
    say "=== #{MODULE_NAME.classify} model has been created ===\n", :green
  end

  def create_policies_file
    say "\n*** Creating #{MODULE_NAME.classify} policy ***"
    policy_path = "#{ROCKET_DIRECTORY}/app/policies/#{ROCKET_NAME}/#{MODULE_NAME.singularize}_policy.rb"
    File.delete(policy_path) if File.exist?(policy_path)
    template('policies/policy.rb', policy_path)
    say "=== #{MODULE_NAME.classify} policy has been created ===\n", :green
  end

  def create_controller_file
    say "\n*** Creating #{MODULE_NAME.pluralize.classify} controller ***"
    controller_path = "#{ROCKET_DIRECTORY}/app/controllers/#{ROCKET_NAME}/admin/#{MODULE_NAME.pluralize}_controller.rb"
    File.delete(controller_path) if File.exist?(controller_path)
    template('controllers/controller.rb', controller_path)
    say "=== #{MODULE_NAME.pluralize.classify}Controller has been created ===\n", :green
  end

  def create_views_files
    %w[
      _description _listing _form
      show edit new index
      reload.js
    ].each do |file_name|
      template_keppler_views("#{file_name}.haml")
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

  def add_str_locales(locale, switch)
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/locales/#{locale}.yml",
      "\n#{str_locales(switch)}",
      after: "#{switch}:"
    )
  end

  def str_route
    <<~HEREDOC
      resources :#{MODULE_NAME} do
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
          url_path: /admin/#{ROCKET_NAME}/#{MODULE_NAME}
          icon: layers
          current: ['/admin/#{ROCKET_NAME}/#{MODULE_NAME}']
          model: #{ROCKET_NAME.singularize.camelize}::#{MODULE_NAME.singularize.camelize}
    HEREDOC
  end

  def str_permissions
    <<~HEREDOC
    #{MODULE_NAME.singularize}:
      name: #{MODULE_NAME.singularize.camelize}
      model: #{ROCKET_NAME.singularize.camelize}#{MODULE_NAME.singularize.camelize}
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

  def template_keppler_views(name_file)
    view_path = "#{ROCKET_DIRECTORY}/app/views/#{ROCKET_NAME}/admin/#{MODULE_NAME}/#{name_file}"
    File.delete(view_path) if File.exist?(view_path)
    template("views/#{name_file}", view_path)
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
      .remove('_rename')
      .remove('_drop')
      .remove('_remove')
      .remove('_column')
      .remove('_from')
      .remove('_to')
      .split('_')
      .flatten[1..-1]
      .join('_')
      .pluralize
  end
end