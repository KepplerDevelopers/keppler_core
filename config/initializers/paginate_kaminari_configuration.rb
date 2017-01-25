# Support for elasticsearch
#Kaminari::Hooks.init
Elasticsearch::Model::Response::Response.__send__(
  :include, Elasticsearch::Model::Response::Pagination::Kaminari
)

Kaminari.configure do |config|
  config.default_per_page = KepplerConfiguration.default_per_page
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
end
