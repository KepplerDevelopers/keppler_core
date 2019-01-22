require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Views::Save, type: :services do
  context 'Save html format' do
    before(:each) do
      @view = create(:keppler_frontend_views, name: "save_code", method: "GET")
      @view.install
      save = KepplerFrontend::Views::Save.new(@view)
      @html = save.code(:html, "<h1>New Title</h1>")
      @css = save.code(:css, ".new-class { color: red; }")
      @js = save.code(:js, "function newFuntion() { alert('new function') }")
      @action = save.code(:actions, '@say_hello = "Hello There"')
    end

    let(:code) { KepplerFrontend::Views::Output.new(@view) }
    
    context 'save code' do
      it { expect(@html).to eq(true) }
      it { expect(code.html).to eq("  <h1>New Title</h1>\n") }
      it { expect(@css).to eq(true) }
      it { expect(code.scss).to eq(".new-class { color: red; }\n") }
      it { expect(@js).to eq(true) }
      it { expect(code.js).to eq("function newFuntion() { alert('new function') }\n") }
      it { expect(@action).to eq(true) }
      it { expect(code.action).to eq("@say_hello = \"Hello There\"\n") }
    end

    after(:each) do
      @view.uninstall
    end
  end

  context 'Output remote format' do
    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET", format_result: "JS")
      @view.install
      save = KepplerFrontend::Views::Save.new(@view)
      @remote_js = save.code(:remote_js, "alert('remote js has been saved')")
    end

    let(:code) { KepplerFrontend::Views::Output.new(@view) }
    
    context 'save code' do
      it { expect(@remote_js).to eq(true) }
      it { expect(code.remote_js).to eq("alert('remote js has been saved')\n") }
    end

    after(:each) do
      @view.uninstall
    end
  end
end