KepplerCapsules::Engine.routes.draw do
  namespace :admin do
    scope :space, as: :capsules do
    end
  end
end
