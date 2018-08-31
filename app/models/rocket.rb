# frozen_string_literal: true

# Rocket Model
class Rocket

  # Rockets list
  def self.names_list
    Dir["#{Rails.root}/rockets/*"].map { |x| x.split('/').last }
  end

  # Catching rocket file and saving in public/rockets
  def self.catch_and_save(rocket_file)
    dir = Rails.root.join('public', 'rockets')
    Dir.mkdir(dir) unless Dir.exist?(dir)
    tmp = rocket_file.tempfile
    destiny_file = File.join("#{Rails.root}/public/rockets")
    FileUtils.move tmp.path, destiny_file
    File.rename(
      "#{destiny_file}/#{tmp.path.split('/')[-1]}",
      "#{destiny_file}/#{rocket_file.original_filename}"
    )
  end

  # Unzipping into rockets folder
  def self.unzip(rocket_file, rocket_name)
    require 'zip'
    Zip::File.open("#{Rails.root}/public/rockets/#{rocket_file.original_filename}") do |zip_file|
      dir = Rails.root.join('rockets', rocket_name)
      Dir.mkdir(dir) unless Dir.exist?(dir)
      zip_file.each do |entry|
        puts "*** Extracting #{entry.name} ***"
        entry.extract("#{Rails.root}/rockets/#{rocket_name}/#{entry.name}")
      end
    end
  end

  # Installing rocket
  def self.run_install(rocket_name)
    system "rails g install_rocket #{rocket_name}"
  end

  # Uninstall rocket
  def self.uninstall(rocket_name)
    system "rails g uninstall_rocket #{rocket_name}"
  end

  # Build rocket
  def self.build(rocket)
    system "cd rockets/#{rocket} && keppler rocket_build"
    system "cd #{Rails.root}"
    dir = Rails.root.join('public', 'rockets')
    Dir.mkdir(dir) unless Dir.exist?(dir)
    system "cp #{Rails.root}/rockets/#{rocket}/pkg/#{rocket}.rocket #{Rails.root}/public/rockets"
  end
end
