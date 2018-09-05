require "bundler/gem_tasks"
task :default => [:spec]

namespace :gem do
  task :build do
    system "rake build && rake install"
  end
end