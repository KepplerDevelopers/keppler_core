# frozen_string_literal: true

class KepplerAddModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  FILE_NAME = "#{(ARGV[0].eql?('keppler_module') ? ARGV[1] : ARGV[0]).underscore.split('keppler_').last}"
  ROCKET_NAME = "keppler_#{FILE_NAME}"
  MODULE_NAME = ARGV[1].underscore
  ATTRIBUTES = ARGV[2] ? ARGV[2..20].map { |x| x.include?(':') ? x.split(':') : ([x, 'string'] if x.exclude?('-')) }.compact.to_h : nil
  ATTRIBUTES_NAMES = ATTRIBUTES.keys
  ROCKET_DIRECTORY = "#{Rails.root}/rockets/#{ROCKET_NAME}"

  ROCKET_CLASS_NAME = "#{ROCKET_NAME}".camelize
  MODULE_CLASS_NAME = MODULE_NAME.singularize.classify

  NAMES = %w[name title first_name full_name]
  SINGULAR_ATTACHMENTS = %w[logo brand photo avatar cover image picture banner attachment pic file]
  PLURAL_ATTACHMENTS = SINGULAR_ATTACHMENTS.map(&:pluralize)
  SEARCHABLE_ATTRIBUTES = ATTRIBUTES.select { |k,v| %w[string].include?(v) && %w[position].exclude?(k) && k.exclude?('-') }.map(&:first).join(' ')

  def create_module
    if ROCKET_NAME
      if MODULE_NAME
        if Dir.exist? ROCKET_DIRECTORY
          say "\n*** Creating #{MODULE_CLASS_NAME} module ***"
          remove_migrations
          # if validate_rocket_scaffold
          #   say "***** RUNNING KEPPLER SCAFFOLD *****"
          #   run_rocket_scaffold
          # else
          add_route
          add_option_menu
          add_locales
          add_option_permissions
          create_model_file
          create_policies_file
          create_controller_file
          create_views_files
          create_migration_file
          # end
          extract_migrations
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

  def add_route
    return if options[:skip_routes]
    say "\n*** Adding routes ***"
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/routes.rb",
      "\n#{indent(str_route, 6)}",
      after: "scope :#{FILE_NAME}, as: :#{FILE_NAME} do"
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
        if FileUtils.rm(migration)
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

  def run_rocket_scaffold
    say "*** Entering to rockets/#{ROCKET_NAME} folder ***"
    FileUtils.cd ROCKET_DIRECTORY
    say "*** Running #{ROCKET_NAME} scaffold ***"
    system "rails g keppler_scaffold #{MODULE_NAME.classify} #{ATTRIBUTES.map { |x| "#{x.first}:#{x.last}" }.join(' ') } position:integer deleted_at:datetime created_at:datetime updated_at:datetime -f"
    say "*** Coming back to Rails root folder ***"
    FileUtils.cd Rails.root
  end

  def create_migration_file
    say "*** Entering to Rocket Directory ***"
    FileUtils.cd ROCKET_DIRECTORY
    say "*** Running 'rails g migration create_#{ROCKET_NAME}_#{MODULE_NAME.pluralize} #{ATTRIBUTES.map { |x| "#{x.first}:#{x.last}" }.join(' ') } position:integer deleted_at:datetime created_at:datetime updated_at:datetime -f' ***"
    system "rails g migration create_#{ROCKET_NAME}_#{MODULE_NAME.pluralize} #{ATTRIBUTES.map { |x| "#{x.first}:#{x.last}" }.join(' ') } position:integer deleted_at:datetime created_at:datetime updated_at:datetime -f"
    say "*** Exiting from Rocket Directory ***"
    FileUtils.cd Rails.root
    say "=== Migration has been created ===\n", :green
  end

  def extract_migrations
    say "*** Importing migrations from #{ROCKET_NAME}/db ***"
    system "rake #{ROCKET_NAME}:install:migrations"
    say "=== Migration has been extracted ===\n", :green
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

  def validate_rocket_scaffold
    File.exist? "#{ROCKET_DIRECTORY}/lib/generators/keppler_scaffold/keppler_scaffold_generator.rb"
  end

  def create_views_files
    say "\n*** Creating #{MODULE_NAME.pluralize.classify} views ***"
    %w[
      _description _form _listing
      edit index new show
      reload.js
    ].each do |filename|
      template_keppler_views("#{filename}.haml")
    end
    say "=== #{MODULE_NAME.pluralize.classify} views have been created ===\n", :green
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

  def template_keppler_views(name_file)
    view_path = "#{ROCKET_DIRECTORY}/app/views/#{ROCKET_NAME}/admin/#{MODULE_NAME.pluralize}/#{name_file}"
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
