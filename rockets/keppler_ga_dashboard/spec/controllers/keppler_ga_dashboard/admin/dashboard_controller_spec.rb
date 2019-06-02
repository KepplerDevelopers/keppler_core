require 'rails_helper'
require 'byebug'

RSpec.describe KepplerGaDashboard::Admin::DashboardController, type: :controller do
  # let(:user) { create(:user) }

  describe 'Filter role' do
    it 'POST to filter role' do
      # sign_in user
      get :analytics
      expect(response).to have_http_status(200)
      expect(response).to render_template('analytics')
    end
  end
end
