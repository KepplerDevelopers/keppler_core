# frozen_string_literal: true

module KepplerFrontend
  module Utils
    # CodeHandler
    class YmlHandler
      def initialize(obj = {})
        @obj = obj
      end

      def update(objs_name)
        file = File.join(config.yml(objs_name))
        data = @obj.as_json.to_yaml
        File.write(file, data)
        true
      rescue StandardError
        false
      end

      def reload(objs_name)
        objs = YAML.load_file(File.join(config.yml(objs_name)))
        objs.each do |obj|
          add_object(objs_name, obj)
        end
        true
      rescue StandardError
        false
      end

      private

      def config
        KepplerFrontend::Urls::Config.new
      end

      def add_object(objs_name, obj)
        objs_name = objs_name.singularize.camelize
        model = "KepplerFrontend::#{objs_name}".constantize
        obj_db = model.where(name: obj[:name]).first
        obj.delete('id')
        return unless obj_db
        model.create(obj.as_json)
      end
    end
  end
end
