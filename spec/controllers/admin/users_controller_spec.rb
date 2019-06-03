require 'rails_helper'
require 'byebug'
require "./spec/shared_stuff.rb"

RSpec.describe Admin::UsersController, type: :controller do
  include_context "allow user and callbacks"
  
  before (:each) do
    allow_callbacks
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
