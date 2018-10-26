# View Model
module KepplerFrontend
  class FileUploadSystem

    def move_and_rename_file(file, new_file)
      root = "#{Rails.root}/public/keppler_frontend/"
      old_name = "#{root}/#{file.filename}"
      new_name = "#{root}/#{new_file.original_filename}"
      folder = select_folder(new_file.original_filename)
      File.rename(old_name, new_name)
      FileUtils.mv(new_name, "#{url_front}/app/assets/#{folder}/keppler_frontend/app/#{new_file.original_filename}")
    end

    def validate_format(file)
      content_type = File.extname(file)
      result = false
      file_formats.each do |key, value|
        result = true if value.include?(content_type)
      end
      result
    end

    def files_list
      files_result = []
      folders.each do |folder|
        files = Dir.entries("#{url_front}/app/assets/#{folder}/keppler_frontend/app")
        files = files.select { |f| f if validate_format(f) }
        files = files.map do |f|
          file_object(f) unless html_cover?(f)
        end
        files_result = files_result + files
      end
      files_result = files_result.select { |f| f unless f.nil? }
      files_result.sort_by { |k| k[:name] }
    end

    def file_object(file)
      folder = select_folder(file)
      file_format = File.extname(file)
      size = File.size("#{url_front}/app/assets/#{folder}/keppler_frontend/app/#{file}")
      cover = "/assets/keppler_frontend/app/#{file.split('.').first}.png"
      cover_url = "#{url_front}/app/assets/html/keppler_frontend/app/#{file.split('.').first}.png"
      {
        id: SecureRandom.uuid,
        name: file,
        url: "#{url_front}/app/assets/#{folder}/keppler_frontend/app/#{file}",
        search: file.split('.').first,
        path: "/assets/keppler_frontend/app/#{file}",
        folder: folder,
        size: filesize(size),
        format: file_format.split('.').last,
        html: folder.eql?('html') ? code_custom('/app', file) : '',
        cover: File.file?(cover_url) ? cover : nil,
        cover_url: File.file?(cover_url) ? cover_url : ''
      }
    end

    def search_with_format(search, file_format)
      files_list.select { |f| f if f[:search].eql?(search) && f[:format].eql?(file_format) }
    end

    def files_list_custom(custom)
      custom = 'app/bootstrap' if custom.eql?('bootstrap')
      files = Dir.entries("#{url_front}/app/assets/html/keppler_frontend/#{custom}")
      files = files.select { |f| f if validate_format(f) && select_folder(f).eql?('html') }
      files = files.map do |file|
        size = File.size("#{url_front}/app/assets/html/keppler_frontend/#{custom}/#{file}")
        cover = "/assets/keppler_frontend/#{custom}/#{file.split('.').first}.png"
        cover_url = "#{url_front}/app/assets/html/keppler_frontend/#{custom}/#{file.split('.').first}.png"
        {
          id: SecureRandom.uuid,
          name: file,
          url: "#{url_front}/app/assets/html/keppler_frontend/#{custom}/#{file}",
          search: file.split('.').first,
          path: "/assets/keppler_frontend/#{custom}/#{file}",
          folder: "#{custom}",
          size: filesize(size),
          format: 'html',
          html: code_custom("/#{custom}", file),
          cover: File.file?(cover_url) ? cover : nil
        }
      end
      files.sort_by { |k| k[:name] }
    end

    def select_folder_by_format(content_type)
      result = ''
      file_formats.each do |key, value|
        result = key.to_s if value.include?(".#{content_type}")
      end
      result
    end

    def select_folder(file)
      content_type = File.extname(file)
      result = ''
      file_formats.each do |key, value|
        result = key.to_s if value.include?(content_type)
      end
      result
    end

    private

    def code_custom(url, name)
      html = File.readlines("#{url_front}/app/assets/html/keppler_frontend#{url}/#{name}")
      html.join
    end

    def html_cover?(file)
      files = []
      folders.each do |folder|
        files = Dir.entries("#{url_front}/app/assets/#{folder}/keppler_frontend/app")
        folder_img = select_folder(file)
        files = files.select { |f| f.eql?(file) && folder_img.eql?('images') }
        return true if !files.count.zero? && folder.eql?('html')
      end
      return false if files.count.zero?
    end

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end

    def filesize(size)
      units = ['B', 'Kb', 'Mb', 'Gb', 'Tb', 'Pb', 'Eb']

      return '0.0 B' if size == 0
      exp = (Math.log(size) / Math.log(1024)).to_i
      exp = 6 if exp > 6

      '%.1f %s' % [size.to_f / 1024 ** exp, units[exp]]
    end

    def folders
      ['audios', 'fonts', 'images', 'videos', 'html', 'javascripts', 'stylesheets']
    end

    def file_formats
      {
        audios: ['.mp3'],
        fonts: ['.eot', '.otf', '.ttf', '.woff', '.woff2'],
        images: ['.jpg', '.jpeg', '.png', '.svg', '.gif', '.tiff', '.bmp'],
        videos: ['.mp4', '.mpeg', '.webm', '.m4v'],
        html: ['.html'],
        javascripts: ['.js', '.coffee', '.js.erb', '.json'],
        stylesheets: ['.css', '.scss', 'sass', '.scss.erb']
      }
    end

  end
end
