# frozen_string_literal: true

# Keppler
module Recoverable
  extend ActiveSupport::Concern
  included do

    def create_yml(model_name)
      file = File.open(file_url(model_name.pluralize), "w")
      objects = model_name.camelize.constantize.pluck(:name)
      file.puts(objects.as_json.to_yaml)
      file.close
      true
    end

    def delete_yml(model_name)
      if File.exist?(file_url(model_name.pluralize))
        File.delete(file_url(model_name.pluralize))
        true
      end
    end

    def update_yml(model_name)
      objects = model_name.camelize.constantize.all
      File.write(file_url(model_name), objects.as_json.to_yaml)
      true
    end

    private

    def url
      "#{Rails.root}/config"
    end

    def file_url(model_name)
      "#{url}/#{model_name}.yml"
    end
  end
end
