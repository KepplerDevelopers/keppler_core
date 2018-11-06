require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::Install, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, format_result: 'JS', method: "GET")
    @files_installed = KepplerFrontend::Views::Install.new(@view)
    @files_unistalled = KepplerFrontend::Views::Uninstall.new(@view)
  end

  let(:js_file) do
    assets = KepplerFrontend::Urls::Assets.new
    assets = assets.core_assets('javascripts', 'app')
    "#{assets}/views/#{@view.name}.js"
  end

  let(:css_file) do
    assets = KepplerFrontend::Urls::Assets.new
    assets = assets.core_assets('stylesheets', 'app')
    "#{assets}/views/#{@view.name}.scss"
  end

  let(:exist_route_active) do
    config = KepplerFrontend::Urls::Config.new
    routes_file = File.readlines(config.routes)
    search = KepplerFrontend::Utils::CodeSearch.new(routes_file)
    idx = search.search_line("  get '/test_index', to: 'app/frontend#test_index', as: :test_index\n")
    idx.zero? ? false : true
  end

  let(:action_exist) do
    front = KepplerFrontend::Urls::Front.new
    controller = File.readlines(front.controller)
    search = KepplerFrontend::Utils::CodeSearch.new(controller)
    idx_one, idx_two = search.search_section("    # begin #{@view.name}\n", 
                                             "    # end #{@view.name}\n")
    controller[idx_one..idx_two].count == 1 ? false : true
  end

  let(:remote_file) do
    front = KepplerFrontend::Urls::Front.new
    front.view_js(@view.name)
  end

  let(:front) { KepplerFrontend::Urls::Front.new }
  
  context 'install' do
    it { expect(@files_installed.install).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(false) }
    it { expect(File.exist?(css_file)).to eq(false) }
    it { expect(File.exist?(js_file)).to eq(false) }
    it { expect(action_exist).to eq(true) }
    it { expect(exist_route_active).to eq(true) }
    it { expect(File.exist?(remote_file)).to eq(true) }
  end

  context 'uninstall' do
    it { expect(@files_unistalled.uninstall).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(false) }
    it { expect(File.exist?(css_file)).to eq(false) }
    it { expect(File.exist?(js_file)).to eq(false) }
    it { expect(action_exist).to eq(false) }
    it { expect(exist_route_active).to eq(false) }
    it { expect(File.exist?(remote_file)).to eq(false) }
  end

end