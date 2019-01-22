require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::JsHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @js = KepplerFrontend::Views::JsHandler.new(@view)
  end

  let(:js_file) do
    assets = KepplerFrontend::Urls::Assets.new
    assets = assets.core_assets('javascripts', 'app')
    "#{assets}/views/#{@view.name}.js"
  end

  let(:js_installed) { @js.install }

  let(:js_content) { File.read(js_file) }
  
  context 'install' do
    it { expect(js_installed).to eq(true) }
    it { expect(File.exist?(js_file)).to eq(true) }
    it { expect(js_content).to eq("// Keppler - test_index.js file\n$(document).ready(function(){\n  // Use jquery functions here\n});\n") }
  end

  context 'output' do 
    it { expect(@js.output).to eq("// Keppler - test_index.js file\n$(document).ready(function(){\n  // Use jquery functions here\n});\n") }
  end

  context 'save code' do
    it { expect(@js.save("function newFuntion() { alert('new function') }")).to eq(true) }
    it { expect(@js.output).to eq("function newFuntion() { alert('new function') }\n") }
  end

  context 'update' do
    let(:view_updated) { @js.update("other_name") }

    let(:asset_url) do
      assets = KepplerFrontend::Urls::Assets.new
      assets.core_assets('javascripts', 'app')
    end

    it { expect(view_updated).to eq(true) }
    it { expect(File.exist?("#{asset_url}/views/other_name.js")).to eq(true) }
    it { expect(File.exist?("#{asset_url}/views/#{@view.name}.js")).to eq(false) }
  end

  context 'uninstall' do
    let(:js_uninstalled) do
      @view.name = 'other_name'
      @js = KepplerFrontend::Views::JsHandler.new(@view)
      @js.uninstall 
    end

    it { expect(js_uninstalled).to eq(true) }
    it { expect(File.exist?(js_file)).to eq(false) }
  end
end