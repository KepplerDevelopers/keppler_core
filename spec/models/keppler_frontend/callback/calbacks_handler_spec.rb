require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::CallbackFunction, type: :model do

  context 'CallbackFunction model' do
    before(:each) do
      @callback = create(:keppler_frontend_callback_functions)

      @front = KepplerFrontend::Urls::Front.new
      @controller = File.readlines(@front.controller)
      @search = KepplerFrontend::Utils::CodeSearch.new(@controller)
    end

    let(:code_install) { @callback.install }

    let(:function_exist) do
      idx_one, idx_two = @search.search_section("    # begin callback #{@callback.name}\n", 
                                               "    # end callback #{@callback.name}\n")
      @controller[idx_one..idx_two].count == 1 ? false : true
    end

    let(:code_uninstall) { @callback.uninstall }

    context 'install' do
      it { expect(code_install).to eq(true) }
      it { expect(function_exist).to eq(true) }
    end

    context 'uninstall' do
      it { expect(code_uninstall).to eq(true) }
      it { expect(function_exist).to eq(false) }
    end
  end
end