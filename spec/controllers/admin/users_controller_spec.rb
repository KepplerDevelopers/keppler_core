require 'rails_helper'
require 'byebug'

RSpec.describe Admin::UsersController, type: :controller do
  before (:each) do
    @user = create(:user)
    sign_in @user
  end

  describe 'Filter role' do
    it 'POST to filter role' do
      post :filter_by_role, format: 'js', xhr: true
      expect(response).to have_http_status(200)
      expect(response).to render_template('filter_by_role')
    end
  end
end
