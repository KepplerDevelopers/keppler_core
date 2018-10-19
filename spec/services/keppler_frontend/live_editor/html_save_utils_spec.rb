require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::HtmlSaveUtils, type: :services do

  context 'html utils' do

    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET")
      @view.install
      @utils = KepplerFrontend::LiveEditor::HtmlSaveUtils.new(@view.name)
      @root = KepplerFrontend::Urls::Roots.new
    end

    context 'get file lines' do
      let(:get_view_lines) { @utils.lines('view') }
      let(:get_layouts_lines) { @utils.lines('layouts') }

      it { expect(get_view_lines).to eq(["<keppler-view id=\"test_index\">\n", "  <h1> test_index template </h1>\n", "</keppler-view>\n"]) }
      it { expect(get_layouts_lines).to eq(["<!DOCTYPE html>\n", "<html id=\"keppler-html\">\n", "  <head>\n", "    <%= set_head %>\n", "  </head>\n", "  <body id=\"keppler-editor\">\n", "    <keppler-header>\n", "      <!-- Keppler Section -->\n", "    </keppler-header>\n", "    <%= yield %>\n", "    <keppler-footer>\n", "      <!-- Keppler Section -->\n", "    </keppler-footer>\n", "  </body>\n", "  <%= keppler_editor %>\n", "</html>\n"]) }
    end

    context 'get url file' do
      let(:get_view_url) { @utils.url('view') }
      let(:get_layouts_url) { @utils.url('layouts') }

      it { expect(get_view_url).to eq("#{@root.rocket_root}/app/views/keppler_frontend/app/frontend/test_index.html.erb") }
      it { expect(get_layouts_url).to eq("#{@root.rocket_root}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb") }
    end

    context 'get find a layout area' do
      let(:header_area) { @utils.find_area(@utils.lines('layouts'), 'header') }
      let(:footer_area) { @utils.find_area(@utils.lines('layouts'), 'footer') }

      it { expect(header_area).to eq([6, 8]) }
      it { expect(footer_area).to eq([10, 12]) }
    end

    context 'get find a view area' do
      let(:view_area) { @utils.find_area(@utils.lines('view'), 'view') }

      it { expect(view_area).to eq([0, 2]) }
    end

    after(:each) do
      @view.uninstall
    end
  end
end