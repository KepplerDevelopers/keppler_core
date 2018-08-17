module KepplerLanguages
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :set_languages

    def set_languages
      @languages = YAML.load_file(
        "#{Rails.root}/rockets/keppler_languages/config/languages.yml"
      ).values.each(&:symbolize_keys!)
    end
  end
end
