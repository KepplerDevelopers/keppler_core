require 'rails_helper'
require 'byebug'

RSpec.describe KepplerGaDashboard::Admin::DashboardController, type: :controller do
  routes { KepplerGaDashboard::Engine.routes }

  describe 'GET /analytics' do
    before do
      allow(controller)
        .to receive(:authenticate_admin_user)
        .and_return(nil)

      allow(controller)
        .to receive(:set_apparience_colors)
        .and_return("#f44336")
    end

    context "successfully" do
      before do
        get :analytics
      end

      it 'must be respone 200' do
        expect(response).to have_http_status(200)
      end

      it 'must render template' do
        expect(response)
          .to render_template("keppler_ga_dashboard/admin/dashboard/analytics")
      end
    end

    context "failure" do
      before do
        allow(Google::APIClient)
          .to receive(:new)
          .and_raise(StandardError.new("error"))

        get :analytics
      end

      it 'must be respone 200' do
        expect(response).to have_http_status(200)
      end

      it 'must render template' do
        expect(response)
          .to render_template("keppler_ga_dashboard/admin/dashboard/connection_error")
      end
    end
  end
end
