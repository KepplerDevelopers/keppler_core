require 'rails_helper'

RSpec.describe KepplerFrontend::Admin::ViewsController, type: :controller do
  let(:user) { create(:user) }

  # describe 'GET to /admin/frontend/views/new' do
  #   let(:response) do
  #     sign_in user
  #     get :new
  #   end
  #   it { expect(response).to have_http_status(200) }
  #   it { expect(response).to render_template('new') }      
  # end

  # describe 'POST to /admin/frontend/views' do
  #   let(:response) do
  #     sign_in user
  #     params = { view: { name:"test_index", url: "/test_index", method: "GET", format_result: "HTML", active: "true", position: "", deleted_at: "" } }
  #     post :create, params: params
  #   end
  #   it { expect(response).to have_http_status(200) }      
  # end

end
