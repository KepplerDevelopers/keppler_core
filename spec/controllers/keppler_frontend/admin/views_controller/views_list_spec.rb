# require 'rails_helper'
# require 'spec_helper'

# RSpec.describe KepplerFrontend::Admin::ViewsController, type: :controller do
#   routes { KepplerFrontend::Engine.routes }
#   let(:user) { create(:user) }

#   describe 'POST to /admin/frontend/views (Admin)' do
#     let(:response) do
#       sign_in user
#       get :index
#     end

#     it { expect(response).to render_template(:index) }
#     it { expect(response).to have_http_status(200) }
#     it { expect(response.content_type).to eq "text/html" }
#   end

#   describe 'POST to /admin/frontend/views (No admin)' do
#     let(:response) do
#       get :index
#     end

#     it { expect(response).not_to render_template(:index) }
#     it { expect(response).to have_http_status(302) }
#     it { expect(response.content_type).to eq "text/html" }
#     it { expect(response).to redirect_to("/users/sign_in") }
#   end

# end
