require 'rails_helper'

RSpec.describe KepplerFrontend::Admin::ViewsController, type: :controller do
  let(:user) { create(:user) }

  let(:html_code) { "<keppler-header>\n<h1>Header Edited</h1>\n</keppler-header>\n<keppler-view id=\"test_index\">\n  <h1>Test Index Edited</h1>\n  <keppler-no-edit id=\"area_two\">\n    <p>area_two</p>\n  </keppler-no-edit>\n</keppler-view>\n\n<keppler-footer>\n<h1>Footer Edited</h1>\n</keppler-footer>" }
  let(:css_code) { ".h1 { color: red; }" }
  let(:front) { KepplerFrontend::Urls::Front.new }
  let(:expected) { { result: true } }

  before(:each) do
    @layout_original = File.read(front.layout)
    @view = create(:keppler_frontend_views, method: "GET")
    @view.install
  end

  describe 'POST to /live_editor/save' do
    let(:response) do
      sign_in user
      params = { use_route: :appointly, html: html_code, css: css_code, view_id: @view.id }
      post :live_editor_save, params: params, format: :json
    end

    it { expect(response).to have_http_status(200) }
    it { expect(response.body).to eq(expected.to_json) }
      
  end
  

  after(:each) do
    @view.uninstall
    out_file = File.open(front.layout, 'w')
    out_file.puts(@layout_original);
    out_file.close
  end
end
