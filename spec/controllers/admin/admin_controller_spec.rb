require 'rails_helper'
require 'byebug'
require "./spec/shared_stuff.rb"

RSpec.describe Admin::AdminController, type: :controller do
  include_context "allow user and callbacks"
  before (:each) do
    allow_callbacks      
  end

  describe 'GET to dashboard' do
    it 'render dashboard if sign in user' do
      sign_in @user
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
