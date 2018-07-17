# frozen_string_literal: true

module Admin
  # AppearanceService
  class AppearanceService
    def style_file
      stylesheets = 'app/assets/stylesheets/admin/utils'
      "#{Rails.root}/#{stylesheets}/_variables.scss"
    end

    def set_default
      appearance = Appearance.last
      appearance.remove_image_background!
      appearance.save
      get_apparience_color('#f44336')
    end

    def get_color(color)
      get_apparience_color(color) if color_exist(color)
    end

    def set_color
      variables_file = File.readlines(style_file)
      color = ''
      variables_file.each do |line|
        color = line[15..21] if line.include?('$keppler-color')
      end
    end

    private

    def get_apparience_color(color)
      variables_file = File.readlines(style_file)
      indx = 0
      variables_file.map do |line|
        include_attr = line.include?('$keppler-color')
        indx = variables_file.find_index(line) if include_attr
      end
      variables_file[indx] = "$keppler-color:#{color};\n"
      variables_file = variables_file.join('')
      File.write(style_file, variables_file)
    end

    def color_exist(color)
      colors = [color]
      !colors.include?('') && !colors.include?(nil)
    end
  end
end
