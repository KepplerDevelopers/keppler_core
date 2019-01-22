require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, format_result: 'JS', method: "GET")
    @files_installed = KepplerFrontend::Views::Install.new(@view)
    assets = KepplerFrontend::Urls::Assets.new
    @assets_js = assets.core_assets('javascripts', 'app')
    @assets_css = assets.core_assets('stylesheets', 'app')
  end

  let(:exist_route_active) do
    config = KepplerFrontend::Urls::Config.new
    routes_file = File.readlines(config.routes)
    search = KepplerFrontend::Utils::CodeSearch.new(routes_file)
    idx = search.search_line("  get '/test_index', to: 'app/frontend#test_index', as: :test_index\n")
    idx.zero? ? false : true
  end

  let(:exist_route_updated) do
    config = KepplerFrontend::Urls::Config.new
    routes_file = File.readlines(config.routes)
    search = KepplerFrontend::Utils::CodeSearch.new(routes_file)
    idx = search.search_line("  get '/test_index', to: 'app/frontend#other_name', as: :other_name\n")
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

  let(:action_updated) do
    front = KepplerFrontend::Urls::Front.new
    controller = File.readlines(front.controller)
    search = KepplerFrontend::Utils::CodeSearch.new(controller)
    idx_one, idx_two = search.search_section("    # begin other_name\n", 
                                             "    # end other_name\n")
    controller[idx_one..idx_two].count == 1 ? false : true
  end

  let(:remote_file) do
    front = KepplerFrontend::Urls::Front.new
    front.view_js(@view.name)
  end

  let(:remote_file_updated) do
    front = KepplerFrontend::Urls::Front.new
    front.view_js('other_name')
  end

  let(:front) { KepplerFrontend::Urls::Front.new }
  
  
  context 'install' do
    it { expect(@files_installed.install).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(false) }    
    it { expect(File.exist?("#{@assets_css}/views/#{@view.name}.scss")).to eq(false) }
    it { expect(File.exist?("#{@assets_js}/views/#{@view.name}.js")).to eq(false) }
    it { expect(action_exist).to eq(true) }
    it { expect(exist_route_active).to eq(true) }
    it { expect(File.exist?(remote_file)).to eq(true) }
  end

  context 'update' do
    let(:files_updated) do
      files = KepplerFrontend::Views::Update.new(@view)
      files.change_name('other_name')
    end

    it { expect(files_updated).to eq(true) }
    it { expect(action_updated).to eq(true) }
    it { expect(File.exist?(remote_file_updated)).to eq(true) }
  end

  context 'uninstall' do
    let(:files_uninstalled) do
      files = KepplerFrontend::Views::Update.new(@view)
      @view.name = 'other_name'
      files.change_name('test_index')
      @view.name = 'test_index'
      files = KepplerFrontend::Views::Uninstall.new(@view)
      files.uninstall
    end

    it { expect(files_uninstalled).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(false) }
    it { expect(File.exist?("#{@assets_css}/views/#{@view.name}.scss")).to eq(false) }
    it { expect(File.exist?("#{@assets_js}/views/#{@view.name}.js")).to eq(false) }
    it { expect(action_exist).to eq(false) }
    it { expect(exist_route_active).to eq(false) }
    it { expect(File.exist?(remote_file)).to eq(false) }
  end

end