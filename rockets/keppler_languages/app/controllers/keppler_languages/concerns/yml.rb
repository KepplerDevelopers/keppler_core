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
        file = "#{url}/config/locales/kl.#{fields.name}.yml"
        yml = YAML.load_file(file)

        data = fields.fields.map { |f| Hash[f.key, f.value] }
        data = data.uniq

        new_hash = fields.fields.map { |f| Hash[f.key, f.value] }
        yml[fields.name.to_s]["keppler_languages"] = new_hash.uniq

        File.open(file, 'w') { |f| YAML.dump(yml, f) }
        delete_underscores(file)
      end

      def delete_underscores(file)
        yml = File.readlines(file)
        yml.each_with_index do |line, index|
          if yml[index].include?('-') && yml[index] != ("---\n")
            yml[index] = yml[index].gsub('-', ' ')
          end
        end

        yml = yml.join('')
        File.write(file, yml)
      end

      def update_languages_yml
        languages = KepplerLanguages::Language.all
        file =  File.join("#{Rails.root}/rockets/keppler_languages/config/languages.yml")
        data = languages.as_json.to_yaml
        File.write(file, data)
      end

      def update_fields_yml
        fields = KepplerLanguages::Field.all
        file =  File.join("#{Rails.root}/rockets/keppler_languages/config/fields.yml")
        data = fields.as_json.to_yaml
        File.write(file, data)
      end

      def url
        "#{Rails.root}/rockets/keppler_languages"
      end

    end
  end
end
