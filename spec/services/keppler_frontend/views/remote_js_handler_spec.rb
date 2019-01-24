require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::RemoteJsHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @remote_js = KepplerFrontend::Views::RemoteJsHandler.new(@view)
  end

  let(:front) { KepplerFrontend::Urls::Front.new }

  let(:remote_file) do
    front = KepplerFrontend::Urls::Front.new
    front.view_js(@view.name)
  end

  let(:remote_installed) { @remote_js.install }

  let(:remote_content) { File.read(remote_file) }
  
  context 'install' do
    it { expect(remote_installed).to eq(true) }
    it { expect(File.exist?(remote_file)).to eq(true) }
    it { expect(remote_content).to eq("// test_index javascript Erb template\n") }
  end

  context 'output' do 
    it { expect(@remote_js.output).to eq("// test_index javascript Erb template\n") }
  end

  context 'save code' do
    it { expect(@remote_js.save("alert('remote js has been saved')")).to eq(true) }
    it { expect(@remote_js.output).to eq("alert('remote js has been saved')\n") }
  end
  
  context 'update' do
    let(:remote_updated) { @remote_js.update("other_name") }

    it { expect(remote_updated).to eq(true) }
    it { expect(File.exist?(front.view_js("other_name"))).to eq(true) }
    it { expect(File.exist?(front.view_js(@view.name))).to eq(false) }
  end

  context 'uninstall' do
    let(:remote_uninstalled) do
      @view.name = 'other_name'
      @remote_js = KepplerFrontend::Views::RemoteJsHandler.new(@view)
      @remote_js.uninstall
    end

    it { expect(remote_uninstalled).to eq(true) }
    it { expect(File.exist?(remote_file)).to eq(false) }
  end
end