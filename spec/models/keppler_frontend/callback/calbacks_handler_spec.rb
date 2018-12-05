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

    let(:function_changed_exist) do
      idx_one, idx_two = @search.search_section("    # begin callback other_name\n", 
                                               "    # end callback other_name\n")
      @controller[idx_one..idx_two].count == 1 ? false : true
    end

    let(:code_change_name) { @callback.change_name("other_name") }

    context 'install' do
      it { expect(code_install).to eq(true) }
      it { expect(function_exist).to eq(true) }
    end

    context 'output' do
      it { expect(@callback.output).not_to eq(false) }
      it { expect(@callback.output).to eq("# Insert ruby code...\n") }
    end

    context 'save' do
      it { expect(@callback.code_save("puts 'Hello world'")).to eq(true) }
      it { expect(@callback.output).to eq("puts 'Hello world'\n") }
    end

    context 'change name' do
      it { expect(code_change_name).to eq(true) }
      it { expect(function_changed_exist).to eq(true) }
    end
      
    context 'uninstall' do
      let(:callback_uninstalled) do
        @callback.name = 'other_name'
        @callback.uninstall
      end

      it { expect(callback_uninstalled).to eq(true) }
      it { expect(function_exist).to eq(false) }
    end
  end
end