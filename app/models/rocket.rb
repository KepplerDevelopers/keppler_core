# frozen_string_literal: true

# Rocket Model
class Rocket < ApplicationRecord
  # Rockets list
  def self.names_list
    Dir["#{Rails.root}/rockets/*"].map do |dir|
      rocket_name = dir.split('/').last
      dir_size = 0
      Dir.glob("#{dir}/**/**").map do |file|
        dir_size += File.size(file)
      end
      "#{rocket_name} (#{filesize(dir_size)})"
    end
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
      uncompress_pkg(zip_file, rocket_name)
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

  # private

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

  def self.uncompress_pkg(zip_file, rocket_name)
    zip_file.each do |entry|
      unless File.exist?("#{Rails.root}/rockets/#{rocket_name}/#{entry.name}")
        puts "*** Extracting #{entry.name} ***"
        entry.extract("#{Rails.root}/rockets/#{rocket_name}/#{entry.name}")
      end
    end
  end

  def self.filesize(size)
    units = %w[B KB MB GB TB Pb EB]
    return '0.0 B' if size.zero?
    exp = (Math.log(size) / Math.log(1024)).to_i
    exp = 6 if exp > 6
    [(size.to_f / 1024**exp).round(2), units[exp]].join(' ')
  end

  def self.parse_name(rocket_name)
    rocket_name
      .remove(':', ';', '\'', '"')
      .downcase
      .parameterize
      .dasherize
      .remove('keppler-')
      .underscore
  end
end
