require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::CssHandler, type: :services do

  context 'css handler' do

    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET")
      @view.install
      @css_handler = KepplerFrontend::LiveEditor::CssHandler.new(@view.name)
    end

    context 'output' do      
      it { expect(@css_handler.output).not_to eq(nil) }
      it { expect(@css_handler.output).not_to eq('') }
      it { expect(@css_handler.output).to be_a(String) } 
    end

    context 'save' do
      before(:each) { @save_css = @css_handler.save("h1 { background: red; }") }

      it { expect(@save_css).to eq(nil) }
      it { expect(@css_handler.output).to eq("h1 {  background: red; }") }
    end 

    after(:each) do
      @view.uninstall
    end 
  end
end