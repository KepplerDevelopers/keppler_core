# frozen_string_literal: true

# Rocket Model
class Rocket < ApplicationRecord
  # Rockets list
  def self.names_list
    Dir["#{Rails.root}/rockets/*"].map { |x| x.split('/').last }
  end

  # Create rocket
  def self.new_rocket(rocket)
    system "rails g new_rocket #{rocket}"
  end

  # Catching rocket file and saving in public/rockets
  def self.save_and_rename(rocket_file)
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
    rocket_zip = "#{Rails.root}/public/rockets/#{rocket_file.original_filename}"
    Zip::File.open(rocket_zip) do |zip_file|
      dir = Rails.root.join('rockets', rocket_name)
      Dir.mkdir(dir) unless Dir.exist?(dir)
      zip_file.each do |entry|
        puts "*** Extracting #{entry.name} ***"
        entry.extract("#{Rails.root}/rockets/#{rocket_name}/#{entry.name}")
      end
    end
  end

  # Installing rocket
  def self.install(rocket_name)
    system "rails g install_rocket #{rocket_name}"
  end

  # Uninstall rocket
  def self.uninstall(rocket_name)
    system "rails g uninstall_rocket #{rocket_name}"
  end

  # Build rocket
  def self.build(rocket)
    rocket_dir = "#{Rails.root}/rockets/#{rocket}"
    Dir.mkdir("#{rocket_dir}/pkg") unless Dir.exist?("#{rocket_dir}/pkg")
    compress_pkg(rocket_dir)
    public_rockets = "#{Rails.root}/public/rockets"
    Dir.mkdir(public_rockets) unless Dir.exist?(public_rockets)
    system "cp #{rocket_dir}/pkg/#{rocket}.rocket #{public_rockets}"
  end

  def self.compress_pkg(rocket_dir)
    archive = "#{rocket_dir}/pkg/#{File.basename(rocket_dir)}.rocket"
    require 'zip'
    return if File.exist? archive
    Zip::File.open(archive, 'w') do |zipfile|
      Dir["#{rocket_dir}/**/**"].reject { |f| f.eql? archive }.each do |file|
        zipfile.add(file.sub(rocket_dir + '/', ''), file)
      end
    end
  end

  private

  def replace_line(relative_destination, regexp, *args, &block)
    path = File.join(destination_root, relative_destination)
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, 'wb') do |file|
      file.write(content)
    end
  end
end
