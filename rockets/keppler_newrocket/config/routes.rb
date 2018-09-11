KepplerNewrocket::Engine.routes.draw do
  namespace :admin do
    scope :newrocket, as: :newrocket do
    end
  end
end
