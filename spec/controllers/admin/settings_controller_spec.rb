require 'rails_helper'
require 'byebug'
require "./spec/shared_stuff.rb"

RSpec.describe Admin::SettingsController, type: :controller do
  include_context "allow user and callbacks"

  before (:each) do
    allow_callbacks
    sign_in @user
  end

  let(:languages) { ["en", "es"] }
  let(:colors) { [ "#3b5998", "#1da1f2", "#e1306c", "#dd4b39", 
                    "#00af87", "#bd081c", "#ff0084", "#1769ff",
                    "#ff8833", "#35465c", "#333333", "#0077b5", 
                    "#ff8800", "#ff0000", "#00aff0", "#162221"
                ] }
  let(:social_medias) { [
    :facebook, :twitter, :instagram, :google_plus,
    :tripadvisor, :pinterest, :flickr, :behance,
    :dribbble, :tumblr, :github, :linkedin,
    :soundcloud, :youtube, :skype, :vimeo
  ] }

  let(:config) { ['configuration', 'appearance', 'basic_information'] }

  describe 'GET to edit' do
    it 'if config parameter is valid' do
      setting = Setting.first
      get :edit, { params: { config: 'configuration' } }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
      expect(assigns(:setting)).to eq(setting)
      expect(assigns(:colors)).to eq(colors)
      expect(assigns(:languages)).to eq(languages)
      expect(assigns(:social_medias)).to eq(social_medias)
    end
  end
end
