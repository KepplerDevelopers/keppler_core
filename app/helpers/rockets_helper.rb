# frozen_string_literal: true

# RocketsHelper
module RocketsHelper
  def rocket_is_built?(rocket)
    File.file?("#{Rails.root}/public/rockets/#{rocket}.rocket")
  end
end
