require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::Output, type: :services do
  context 'Output html format' do
    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET")
      @view.install
      @code = KepplerFrontend::Views::Output.new(@view)
    end
    
    context 'code outputs' do
      it { expect(@code.html).to eq("  <h1> test_index template </h1>\n") }
      it { expect(@code.scss).to eq("/* Keppler - test_index.scss file */\n") }
      it { expect(@code.js).to eq("// Keppler - test_index.js file\n$(document).ready(function(){\n  // Use jquery functions here\n});\n") }
      it { expect(@code.action).to eq("# Insert ruby code...\n") }
    end

    after(:each) do
      @view.uninstall
    end
  end

  context 'Output remote format' do
    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET", format_result: "JS")
      @view.install
      @code = KepplerFrontend::Views::Output.new(@view)
    end
    
    context 'code outputs' do
      it { expect(@code.remote_js).to eq("// test_index javascript Erb template\n") }
    end

    after(:each) do
      @view.uninstall
    end
  end
end