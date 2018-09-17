class InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def some_code
    puts '##### Running some code #####'
  end
end
