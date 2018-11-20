KepplerGaDashboard::Engine.routes.draw do
  get '/', to: 'admin/dashboard#analytics'
end
