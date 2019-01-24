require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::View, type: :services do

  context 'Callback handler' do
    before(:each) do
      @function_type = "before_action"
      @view = create(:keppler_frontend_views, method: "GET")
      @callback = create(:keppler_frontend_callback_functions, name: "test_callback_model")
      @view_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, view_id: @view.id, function_type: @function_type)
      @params_callback = {"1544033797333"=>{name: @callback.name, function_type: @function_type, _destroy: "false"}}

      @front = KepplerFrontend::Urls::Front.new
      @controller = File.readlines(@front.controller)
      @search = KepplerFrontend::Utils::CodeSearch.new(@controller)
    end

    let(:action_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    #{@function_type} :test_callback_model, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    context 'add callback line' do
      it { expect(@view.new_callback(@params_callback)).to eq(true) }
      it { expect(action_exist).to eq(true) }
    end

    context 'remove callback line' do
      it 'destroy callback' do
        @view_callback.destroy
        expect(@view.remove_callback(@view_callback)).to eq(true)
      end
      it { expect(action_exist).to eq(false) }
    end
  end
end