require 'rails_helper'

RSpec.describe Admin::RocketsController, type: :controller do
  let(:user) { create(:user) }
  let(:rockets) { Rocket.all }

  describe 'DELETE to uninstall' do
    it "don't delete frontend and render rockets list" do
      sign_in user
      delete :uninstall, { params: { rocket: 'keppler_frontend' } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/admin/rockets')
    end
  end
end
