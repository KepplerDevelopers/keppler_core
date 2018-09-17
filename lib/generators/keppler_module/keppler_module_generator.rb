class KepplerModuleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  rocket_name = ARGV[0] ? ARGV[0].split('keppler_').last : nil
  puts "\n!!! Error: Please insert rocket name !!!\n" if rocket_name.nil?
  ROCKET_NAME = rocket_name

  module_name = ARGV[1] ? ARGV[1].split('keppler_').last : nil
  puts "\n!!! Error: Please insert module name !!!\n" if module_name.nil?
  MODULE_NAME = module_name

  rocket_directory = "#{Rails.root}/rockets/keppler_#{ROCKET_NAME}"
  puts "\n!!! Error: Rocket doesn't exist !!!\n" unless Dir.exist? rocket_directory
  ROCKET_DIRECTORY = rocket_directory

  def create_module
    if Dir.exists? ROCKET_DIRECTORY
      add_route
      add_option_menu
      add_option_permissions
      add_locales
      say "\n=== All Done. #{MODULE_NAME.camelize} module has been created and installed ===\n", :green
    else
      say "\n !!! This rocket doesn't exist !!!", :red
    end
  end
  
  private

  def add_route
    return if options[:skip_routes]
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/routes.rb",
      "\n#{indent(str_route, 6)}",
      after: "scope :#{ROCKET_NAME}, as: :#{ROCKET_NAME} do"
    )
  end

  def add_option_menu
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/menu.yml",
      "\n#{indent(str_menu, 6)}",
      after: 'submenu:'
    )
  end

  def add_option_permissions
    inject_into_file(
      "#{ROCKET_DIRECTORY}/config/permissions.yml",
      "\n#{indent(str_permissions, 2)}",
      after: 'modules:'
    )
  end

  def add_locales
    %w[en es].each do |locale|
      %w[singularize pluralize modules sidebar-menu].each do |switch|
        add_str_locales(locale, switch)
      end
    end
  end

  def create_controller_files
    template(
      'controllers/controller.rb',
      File.join(
        'app/controllers/admin',
        controller_class_path, "#{MODULE_NAME}_controller.rb"
      )
    )
  end

  def create_model_files
    model_path = File.join('app/models', controller_class_path, "#{MODULE_NAME.singularize}.rb")
    File.delete(model_path) if File.exist?(model_path)
    attachments
    template(
      'models/model.rb',
      File.join(
        'app/models',
        controller_class_path,
        "#{MODULE_NAME.singularize}.rb"
      )
    )
  end

  def create_policies_files
    template(
      'policies/policy.rb',
      File.join(
        'app/policies',
        controller_class_path,
        "#{MODULE_NAME.singularize}_policy.rb"
      )
    )
  end

  def create_views_files
    names
    attachments
    %w[
      _description _index_show _listing _form show edit new index
      show.js reload.js
    ].each do |file_name|
      template_keppler_views("#{file_name}.haml")
    end
  end

  # hook_for :test_framework, as: :scaffold

  # # Invoke the helper using the controller name (pluralized)
  # hook_for :helper, as: :scaffold do |invoked|
  #   invoke invoked, [controller_name]
  # end

  private

  def names
    @names = %w[name title first_name full_name]
  end

  def attachments
    @attachments = %w[logo brand photo avatar cover image picture banner attachment pic file]
    @attachments.map { |a| [a, a.pluralize].join(' ') }.join(' ').split
  end

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
          url_path: admin/#{ROCKET_NAME}/#{MODULE_NAME}
          icon: layers
          current: ['admin/#{ROCKET_NAME}/#{MODULE_NAME}']
          model: Keppler#{ROCKET_NAME.singularize.camelize}::#{MODULE_NAME.singularize.camelize}
    HEREDOC
  end

  def str_permissions
    <<~HEREDOC
    #{MODULE_NAME.singularize}:
      name: #{MODULE_NAME.singularize.camelize}
      model: Keppler#{ROCKET_NAME.singularize.camelize}#{MODULE_NAME.singularize.camelize}
      actions: %w[
        index create update destroy download upload clone
      ]
    HEREDOC
  end

  def str_locales(switch)
    case switch
    when 'sidebar-menu'
      "      #{MODULE_NAME.dasherize}: #{MODULE_NAME.humanize}"
    when 'singularize'
      "        #{MODULE_NAME.singularize}: #{MODULE_NAME.singularize.humanize.downcase}"
    when 'pluralize'
      "        #{MODULE_NAME.pluralize}: #{MODULE_NAME.pluralize.humanize.downcase}"
    when 'modules'
      "      admin/#{MODULE_NAME.dasherize}: #{MODULE_NAME.humanize}"
    end
  end

  def template_keppler_views(name_file)
    template(
      "views/#{name_file}",
      File.join("#{ROCKET_DIRECTORY}/app/views/admin/#{MODULE_NAME}", name_file)
    )
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
end
