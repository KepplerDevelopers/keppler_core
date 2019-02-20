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
      

      @before_action_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                               view_id: @view.id, 
                                                               function_type: "before_action")
      @before_filter_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                                view_id: @view.id, 
                                                                function_type: "before_filter")
      @after_action_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                                view_id: @view.id, 
                                                                function_type: "after_action")
      @after_filter_callback = create(:keppler_frontend_view_callbacks, name: @callback.name, 
                                                                view_id: @view.id, 
                                                                function_type: "after_filter")
    end

    let(:before_action) do
      KepplerFrontend::Callbacks::CodeViews.new(@view, @before_action_callback)
    end

    let(:before_action_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    before_action :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    let(:before_filter) do      
      KepplerFrontend::Callbacks::CodeViews.new(@view, @before_filter_callback)
    end

    let(:before_filter_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    before_filter :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    let(:after_action) do
      KepplerFrontend::Callbacks::CodeViews.new(@view, @after_action_callback)
    end

    let(:after_action_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    after_action :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    let(:after_filter) do
      KepplerFrontend::Callbacks::CodeViews.new(@view, @after_filter_callback )
    end

    let(:after_filter_exist) do
      ctrl = File.readlines(@front.controller)
      line = "    after_filter :test_callback, only: [:test_index]\n"
      ctrl.include?(line) ? true : false
    end

    context 'add callback line' do
      it { expect(before_action.change).to eq(true) }
      it { expect(before_action_exist).to eq(true) }
      it { expect(before_filter.change).to eq(true) }
      it { expect(before_filter_exist).to eq(true) }
      it { expect(after_action.change).to eq(true) }
      it { expect(after_action_exist).to eq(true) }
      it { expect(after_filter.change).to eq(true) }
      it { expect(after_filter_exist).to eq(true) }
    end

    context 'remove callback line' do
      it 'remove before action' do 
        @before_action_callback.destroy
        expect(before_action.change).to eq(true)
      end
      it { expect(before_action_exist).to eq(false) }
      it 'remove before filter' do 
        @before_filter_callback.destroy
        expect(before_filter.change).to eq(true)
      end
      it { expect(before_filter_exist).to eq(false) }
      it 'remove after_action' do 
        @after_action_callback.destroy
        expect(after_action.change).to eq(true)
      end
      it { expect(after_action_exist).to eq(false) }
      it 'remove after_filter' do 
        @after_filter_callback.destroy
        expect(after_filter.change).to eq(true)
      end
      it { expect(after_filter_exist).to eq(false) }
    end
  end
end