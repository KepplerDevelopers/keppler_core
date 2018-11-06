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

  let(:css_uninstalled) { @css.uninstall }

  let(:css_content) { File.read(css_file) }
  
  context 'install' do
    it { expect(css_installed).to eq(true) }
    it { expect(File.exist?(css_file)).to eq(true) }
    it { expect(css_content).to eq("/* Keppler - test_index.scss file */\n") }
  end

  context 'uninstall' do
    it { expect(css_uninstalled).to eq(true) }
    it { expect(File.exist?(css_file)).to eq(false) }
  end
end