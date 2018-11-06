require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::HtmlHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @html = KepplerFrontend::Views::HtmlHandler.new(@view)
  end

  let(:front) { KepplerFrontend::Urls::Front.new }

  let(:view_installed) { @html.install }

  let(:view_uninstalled) { @html.uninstall }

  let(:view_html) { File.read(front.view(@view.name)) }

  context 'install' do
    it { expect(view_installed).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(true) }
    it { expect(view_html).to eq("<keppler-view id=\"test_index\">\n  <h1> test_index template </h1>\n</keppler-view>\n") }
  end

  context 'uninstall' do
    it { expect(view_uninstalled).to eq(true) }
    it { expect(File.exist?(front.view(@view.name))).to eq(false) }
  end
end