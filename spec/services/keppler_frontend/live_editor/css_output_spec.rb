require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::CssHandler, type: :services do

  context 'css handler' do
    context 'output' do
        before(:each) do
          @view = create(:keppler_frontend_views, method: "GET")
          @view.install
          @css_handler = KepplerFrontend::LiveEditor::CssHandler.new(@view.name)
        end

        it { expect(@css_handler.output).not_to eq(nil) }
        it { expect(@css_handler.output).not_to eq('') }
        it { expect(@css_handler.output).to be_a(String) }

        after(:each) do
          @view.uninstall
        end   
    end
  end
end