require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Callbacks::CodeViews, type: :services do

  context 'Callback handler' do
    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET")
      @callback = create(:keppler_frontend_callback_functions)

      @front = KepplerFrontend::Urls::Front.new
      @controller = File.readlines(@front.controller)
      @search = KepplerFrontend::Utils::CodeSearch.new(@controller)
    end

    let(:before_action) do
      view_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                               view_id: @view.id, 
                                                               function_type: "before_action")
      KepplerFrontend::Callbacks::CodeViews.new(@view, view_callback)
    end

    let(:before_action_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    before_action :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    let(:before_filter) do
      view_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                               view_id: @view.id, 
                                                               function_type: "before_filter")
      KepplerFrontend::Callbacks::CodeViews.new(@view, view_callback)
    end

    let(:before_filter_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    before_filter :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    let(:after_action) do
      view_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                               view_id: @view.id, 
                                                               function_type: "after_action")
      KepplerFrontend::Callbacks::CodeViews.new(@view, view_callback)
    end

    let(:after_action_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    after_action :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    let(:after_filter) do
      view_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                               view_id: @view.id, 
                                                               function_type: "after_filter")
      KepplerFrontend::Callbacks::CodeViews.new(@view, view_callback)
    end

    let(:after_filter_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    after_filter :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    context 'add callback line' do
      it { expect(before_action.add).to eq(true) }
      it { expect(before_action_exist).to eq(true) }
      it { expect(before_filter.add).to eq(true) }
      it { expect(before_filter_exist).to eq(true) }
      it { expect(after_action.add).to eq(true) }
      it { expect(after_action_exist).to eq(true) }
      it { expect(after_filter.add).to eq(true) }
      it { expect(after_filter_exist).to eq(true) }
    end

    context 'remove callback line' do
      it { expect(before_action.remove).to eq(true) }
      it { expect(before_action_exist).to eq(false) }
      it { expect(before_filter.remove).to eq(true) }
      it { expect(before_filter_exist).to eq(false) }
      it { expect(after_action.remove).to eq(true) }
      it { expect(after_action_exist).to eq(false) }
      it { expect(after_filter.remove).to eq(true) }
      it { expect(after_filter_exist).to eq(false) }
    end

    context 'remove callback line' do
    end
  end
end