require "rails_helper"

RSpec.describe SeosController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/seos").to route_to("seos#index")
    end

    it "routes to #new" do
      expect(:get => "/seos/new").to route_to("seos#new")
    end

    it "routes to #show" do
      expect(:get => "/seos/1").to route_to("seos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/seos/1/edit").to route_to("seos#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/seos").to route_to("seos#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/seos/1").to route_to("seos#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/seos/1").to route_to("seos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/seos/1").to route_to("seos#destroy", :id => "1")
    end
  end
end
