module FrontsHelper

  def navbar
    render "app/front/partials/navbar"
  end

  def go_to_top
    render "app/front/partials/go_to_top"
  end

  def header_logos
    render "app/front/partials/header_logos"
  end

  def services
    render "app/front/partials/services"
  end
end
