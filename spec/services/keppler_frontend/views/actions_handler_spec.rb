require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::ActionsHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @action = KepplerFrontend::Views::ActionsHandler.new(@view)
  end

  let(:action_installed) { @action.install }

  let(:action_uninstalled) { @action.uninstall }

  let(:action_exist) do
    front = KepplerFrontend::Urls::Front.new
    controller = File.readlines(front.controller)
    search = KepplerFrontend::Utils::CodeSearch.new(controller)
    idx_one, idx_two = search.search_section("    # begin #{@view.name}\n", 
                                             "    # end #{@view.name}\n")
    controller[idx_one..idx_two].count == 1 ? false : true
  end
  
  context 'install' do
    it { expect(action_installed).to eq(true) }
    it { expect(action_exist).to eq(true) }
  end

  context 'uninstall' do
    it { expect(action_uninstalled).to eq(true) }
    it { expect(action_exist).to eq(false) }
  end
end