class FrontendController < ApplicationController
	layout 'layouts/frontend/application'
	
  def index
  	@sections = [
  		{selector: "one", name: "Discovery Los Roques", url:"discover"},
  		{selector: "three", name: "Diving", url:"diving"},
  		{selector: "four", name: "Fishing", url:"fishing"},
  		{selector: "five", name: "Kiteboarding", url:"kiteboarding"}
  	]
  end

  def discover
    
  end

  def diving
    
  end

  def fishing
    
  end

  def kiteboarding
    
  end
end
