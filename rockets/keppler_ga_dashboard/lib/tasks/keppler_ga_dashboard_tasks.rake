require File.expand_path('../../keppler_ga_dashboard/tasks/install', __FILE__)

namespace :dashboard do
	desc 'Copiar inicializador para la configuración'
	task :run do
		KepplerGaDashboard::Tasks::Install.run
	end

  desc 'Copiar vista del proyecto'
  task :copy_view do
    KepplerGaDashboard::Tasks::Install.copy_view
  end
end
