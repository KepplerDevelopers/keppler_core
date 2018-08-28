module KepplerLanguages
  module LanguagesHelper
    def translate(str)
      t("keppler_languages.#{str.to_s}")
    end
  end
end
