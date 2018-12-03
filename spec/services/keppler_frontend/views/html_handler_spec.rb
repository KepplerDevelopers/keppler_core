require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::HtmlHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @html = KepplerFrontend::Views::HtmlHandler.new(@view)
  end

  let(:front) { KepplerFrontend::Urls::Front.new }

  let(:view_installed) { @html.install }

  let(:view_html) { File.read(front.view(@view.name)) }

  context 'install' do
    it { expect(view_installed).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(true) }
    it { expect(view_html).to eq("<keppler-view id=\"test_index\">\n  <h1> test_index template </h1>\n</keppler-view>\n") }
  end

  context 'output' do 
    it { expect(@html.output).to eq("  <h1> test_index template </h1>\n") }
  end

  context 'save code' do
    it { expect(@html.save('<h1> New Title </h1>')).to eq(true) }
    it { expect(@html.output).to eq("  <h1> New Title </h1>\n") }
  end

  context 'update' do
    let(:view_updated) { @html.update("other_name") }

    it { expect(view_updated).to eq(true) }
    it { expect(File.exist?(front.view("other_name"))).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(false) }
  end

  context 'uninstall' do
    let(:view_uninstalled) do
      @view.name = 'other_name'
      @html = KepplerFrontend::Views::HtmlHandler.new(@view)
      @html.uninstall
    end
    
    it { expect(view_uninstalled).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(false) }
  end

  
end