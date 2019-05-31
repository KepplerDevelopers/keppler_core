require 'rails_helper'

RSpec.describe Admin::RocketsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE to uninstall' do
    it "don't delete frontend and render rockets list" do
      sign_in user
      delete :uninstall, { params: { rocket: 'keppler_frontend' } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/alert/403')
    end

    it "don't delete dashboard and render rockets list" do
      sign_in user
      delete :uninstall, { params: { rocket: 'keppler_ga_dashboard' } }
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/alert/403')
    end
  end
end
