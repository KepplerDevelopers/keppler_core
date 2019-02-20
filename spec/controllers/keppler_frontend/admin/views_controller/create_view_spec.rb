# require 'rails_helper'

# RSpec.describe KepplerFrontend::Admin::ViewsController, type: :controller do
#   routes { KepplerFrontend::Engine.routes }
#   let(:user) { create(:user) }


#   context "When user is admin" do
#     describe 'GET to /admin/frontend/views/new' do
#       let(:response) do
#         sign_in user
#         get :new
#       end
#       it { expect(response).to have_http_status(200) }
#       it { expect(response).to render_template(:new) }    
#       it { expect(response.content_type).to eq "text/html" }  
#     end
  
#     describe 'POST to /admin/frontend/views' do
#       let(:response) do
#         sign_in user
#         params = { view: { name:"test_index_two", url: "/test_index_two", method: "GET", format_result: "HTML", active: "true", position: "", deleted_at: "" } }
#         post :create, params: params
#       end
#       it { expect(response).to have_http_status(302) }
#       it { expect(response).to redirect_to("/admin/frontend/views/#{assigns(:view).id}/editor") }

#       after(:each) do
#         assigns(:view).uninstall
#       end
#     end

#   end

# end
