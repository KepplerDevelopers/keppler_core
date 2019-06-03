require 'rails_helper'
require "./spec/shared_stuff.rb"

RSpec.describe Admin::RocketsController, type: :controller do
  include_context "allow user and callbacks"

  before (:each) do
    allow_callbacks      
    sign_in @user
  end

  describe 'DELETE to uninstall' do
    it "don't delete frontend and render rockets list" do
      delete :uninstall, { params: { rocket: 'keppler_frontend' } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/alert/403')
    end

    it "don't delete dashboard and render rockets list" do
      delete :uninstall, { params: { rocket: 'keppler_ga_dashboard' } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/alert/403')
    end
  end
end
