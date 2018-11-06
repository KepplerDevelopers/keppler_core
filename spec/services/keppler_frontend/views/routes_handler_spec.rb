require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::RoutesHandler, type: :services do

  before(:each) do
    @view_active = create(:keppler_frontend_views, method: "GET")
    @route_active = KepplerFrontend::Views::RoutesHandler.new(@view_active)
    @view_inactive = create(:keppler_frontend_views, name: 'test_index_two', 
                                                     url: '/test_index_two', 
                                                     method: "GET", 
                                                     active: false)
    @route_inactive = KepplerFrontend::Views::RoutesHandler.new(@view_inactive)
  end

  context 'when route is active' do
    let(:routes_installed) { @route_active.install }

    let(:routes_uninstalled) { @route_active.uninstall }

    let(:exist_route_active) do
      config = KepplerFrontend::Urls::Config.new
      routes_file = File.readlines(config.routes)
      search = KepplerFrontend::Utils::CodeSearch.new(routes_file)
      idx = search.search_line("  get '/test_index', to: 'app/frontend#test_index', as: :test_index\n")
      idx.zero? ? false : true
    end

    context 'install' do
      it { expect(routes_installed).to eq(true) }
      it { expect(exist_route_active).to eq(true) }
    end

    context 'uninstall' do
      it { expect(routes_uninstalled).to eq(true) }
      it { expect(exist_route_active).to eq(false) }
    end
  end

  context 'when route is inactive' do
    let(:routes_inactive_installed) { @route_inactive.install }

    let(:routes_inactive_uninstalled) { @route_inactive.uninstall }

    let(:exist_route_inactive) do
      config = KepplerFrontend::Urls::Config.new
      routes_file = File.readlines(config.routes)
      search = KepplerFrontend::Utils::CodeSearch.new(routes_file)
      idx = search.search_line("#  get '/test_index_two', to: 'app/frontend#test_index_two', as: :test_index_two\n")
      idx.zero? ? false : true
    end

    context 'install' do
      it { expect(routes_inactive_installed).to eq(true) }
      it { expect(exist_route_inactive).to eq(true) }
    end

    context 'uninstall' do
      it { expect(routes_inactive_uninstalled).to eq(true) }
      it { expect(exist_route_inactive).to eq(false) }
    end
  end
end