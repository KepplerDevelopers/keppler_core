require 'rails_helper'

RSpec.describe Admin::AdminController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET to dashboard' do
    it 'render dashboard if sign in user' do
      sign_in user
      get :root
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/admin/dashboard')
    end

    it 'render dashboard if not sign in user' do
      get :root
      expect(response).to have_http_status(302)
      expect(response).to redirect_to('/')
    end
  end
end
