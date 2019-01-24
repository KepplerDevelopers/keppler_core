require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::CssHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @css = KepplerFrontend::Views::CssHandler.new(@view)
  end

  let(:css_file) do
    assets = KepplerFrontend::Urls::Assets.new
    assets = assets.core_assets('stylesheets', 'app')
    "#{assets}/views/#{@view.name}.scss"
  end

  let(:css_installed) { @css.install }

  let(:css_content) { File.read(css_file) }
  
  context 'install' do
    it { expect(css_installed).to eq(true) }
    it { expect(File.exist?(css_file)).to eq(true) }
    it { expect(css_content).to eq("/* Keppler - test_index.scss file */\n") }
  end

  context 'output' do 
    it { expect(@css.output).to eq("/* Keppler - test_index.scss file */\n") }
  end

  context 'save code' do
    it { expect(@css.save('.new-class { color: red; }')).to eq(true) }
    it { expect(@css.output).to eq(".new-class { color: red; }\n") }
  end

  context 'update' do
    let(:view_updated) { @css.update("other_name") }

    let(:asset_url) do
      assets = KepplerFrontend::Urls::Assets.new
      assets.core_assets('stylesheets', 'app')
    end

    it { expect(view_updated).to eq(true) }
    it { expect(File.exist?("#{asset_url}/views/other_name.scss")).to eq(true) }
    it { expect(File.exist?("#{asset_url}/views/#{@view.name}.scss")).to eq(false) }
  end

  context 'uninstall' do
    let(:css_uninstalled) do
      @view.name = 'other_name'
      @css = KepplerFrontend::Views::CssHandler.new(@view)
      @css.uninstall
    end

    it { expect(css_uninstalled).to eq(true) }
    it { expect(File.exist?(css_file)).to eq(false) }
  end
end