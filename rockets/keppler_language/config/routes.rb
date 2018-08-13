KepplerLanguage::Engine.routes.draw do
  namespace :admin do
    scope :language, as: :language do
    end
  end
end
