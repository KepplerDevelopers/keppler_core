require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::ActionsHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @action = KepplerFrontend::Views::ActionsHandler.new(@view)

    @front = KepplerFrontend::Urls::Front.new
    @controller = File.readlines(@front.controller)
    @search = KepplerFrontend::Utils::CodeSearch.new(@controller)
  end

  let(:action_installed) { @action.install }

  let(:action_exist) do
    idx_one, idx_two = @search.search_section("    # begin #{@view.name}\n", 
                                             "    # end #{@view.name}\n")
    @controller[idx_one..idx_two].count == 1 ? false : true
  end
  
  context 'install' do
    it { expect(action_installed).to eq(true) }
    it { expect(action_exist).to eq(true) }
  end

  context 'output' do 
    it { expect(@action.output).to eq("# Insert ruby code...\n") }
  end

  context 'save code' do
    it { expect(@action.save('@say_hello = "Hello There"')).to eq(true) }
    it { expect(@action.output).to eq("@say_hello = \"Hello There\"\n") }
  end

  context 'update' do
    let(:action_updated) { @action.update('other_name') }

    let(:action_updated_exist) do
      idx_one, idx_two = @search.search_section("    # begin other_name\n", 
                                               "    # end other_name\n")
      @controller[idx_one..idx_two].count == 1 ? false : true
    end

    it { expect(action_updated).to eq(true) }
    it { expect(action_updated_exist).to eq(true) }
  end

  context 'uninstall' do
    let(:action_uninstalled) do
      @view.name = 'other_name'
      @action.uninstall
    end

    it { expect(action_uninstalled).to eq(true) }
    it { expect(action_exist).to eq(false) }
  end
end