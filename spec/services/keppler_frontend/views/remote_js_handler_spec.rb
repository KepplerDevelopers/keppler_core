require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::RemoteJsHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @remote_js = KepplerFrontend::Views::RemoteJsHandler.new(@view)
  end

  let(:remote_file) do
    front = KepplerFrontend::Urls::Front.new
    front.view_js(@view.name)
  end

  let(:remote_installed) { @remote_js.install }

  let(:remote_uninstalled) { @remote_js.uninstall }

  let(:remote_content) { File.read(remote_file) }
  
  context 'install' do
    it { expect(remote_installed).to eq(true) }
    it { expect(File.exist?(remote_file)).to eq(true) }
    it { expect(remote_content).to eq("// test_index javascript Erb template\n") }
  end

  context 'uninstall' do
    it { expect(remote_uninstalled).to eq(true) }
    it { expect(File.exist?(remote_file)).to eq(false) }
  end
end