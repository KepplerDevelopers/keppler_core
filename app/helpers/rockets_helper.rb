# frozen_string_literal: true

# RocketsHelper
module RocketsHelper
  def rocket_is_built?(rocket)
    File.file?("#{Rails.root}/public/rockets/#{rocket}.rocket")
  end

  def can_uninstall?(rocket_name)
    RocketPolicy.new(current_user, rocket_name).uninstall?
  end
end
