# frozen_string_literal: true

module Admin
  # MetaTagController
  class RocketsController < AdminController
    # GET /meta_tags
    def rockets
      @rockets = Dir["#{Rails.root}/rockets/*"].map { |x| x.split('/').last }
    end

    def install_rocket
      rocket_params

      if rocket_file && rocket_ext.eql?('rocket')
        # Catching rocket file and saving in public/rockets
        catch_and_save_rocket(rocket_file)
        # Unzipping into rockets folder
        unzip_rocket(rocket_file)
        # Installing rocket
        run_install_rocket(rocket_name)

        flash[:notice] = "#{rocket_name} has been installed"
      else
        flash[:error] = "#{rocket_name} has not been installed"
      end
      redirect_to admin_rockets_path
    end

    private

    def rocket_params
      rocket_file = params[:rocket]
      rocket_name = rocket_file.split('.').first
      rocket_ext = rocket_file.split('.').last
    end

    def catch_and_save_rocket(rocket_file)
      # Catching rocket file and saving in public/rockets
      dir = Rails.root.join('public', 'rockets')
      Dir.mkdir(dir) unless Dir.exist?(dir)
      File.open(dir.join(rocket_file.original_rocket_name), 'wb') do |file|
        file.write(rocket_file.read)
      end
    end

    def unzip_rocket(rocket_file)
      # Unzipping into rockets folder
      Zip::File.open("#{Rails.root}/public/rockets/#{rocket_file}") do |zip_file|
        # Handle entries one by one
        zip_file.each do |entry|
          # Extract to file/directory/symlink
          puts "Extracting #{entry.name}"
          entry.extract(dest_file)

          # Read into memory
          content = entry.get_input_stream.read
        end

        # Find specific entry
        entry = zip_file.glob('*.csv').first
        puts entry.get_input_stream.read
      end
    end

    def run_install_rocket(rocket_name)
      # Installing rocket
      system "rails g install_rocket #{rocket_name}"
    end
  end
end
