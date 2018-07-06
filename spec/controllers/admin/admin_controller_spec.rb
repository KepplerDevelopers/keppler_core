require 'rails_helper'

RSpec.describe Admin::AdminController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET to dashboard' do
    it 'request to root' do
      sign_in user
      get :root
      expect(response).to have_http_status(302)
    end
  end
end
