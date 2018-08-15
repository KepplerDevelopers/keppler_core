module KepplerLanguages
  module Concerns
    # Concern con la configuracion de parametros de los formulario
    module Yml
      extend ActiveSupport::Concern

      included do
      end

      private

      def update_yml(id)
        fields = KepplerLanguages::Language.find(id)
        file = "#{url}/config/locales/#{fields.name}.yml"
        yml = File.readlines(file)
        head_idx = 0
        yml.each do |i|
          head_idx = yml.find_index(i) if i.include?("keppler_languages:")
        end
        data = fields.fields.map { |f| "#{f.key}: #{f.value}" }
        data = data.uniq

        data.each_with_index do |d, index|
          yml.insert(head_idx.to_i + index + 1, "  #{d}\n")
        end

        yml = yml.join('')
        File.write(file, yml)
      end

      def reset_yml(fields)
        file = "#{url}/config/locales/#{fields.name}.yml"


      end

      def url
        "#{Rails.root}/rockets/keppler_languages"
      end

    end
  end
end
