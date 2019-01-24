require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::View, type: :model do

  context 'View files handler' do

    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET")
    end

    context 'install' do
      it { expect(@view.install).to eq(true) }
    end

    context 'output' do
      it { expect(@view.output_html).to eq("  <h1> test_index template </h1>\n") }
      it { expect(@view.output_scss).to eq("/* Keppler - test_index.scss file */\n") }
      it { expect(@view.output_js).to eq("// Keppler - test_index.js file\n$(document).ready(function(){\n  // Use jquery functions here\n});\n") }
      it { expect(@view.output_action).to eq("# Insert ruby code...\n") }
    end

    context 'save' do
      it { expect(@view.save_code(:html, "<h1>New Title</h1>")).to eq(true) }
      it { expect(@view.save_code(:css, ".new-class { color: red; }")).to eq(true) }
      it { expect(@view.save_code(:js, "function newFuntion() { alert('new function') }")).to eq(true) }
      it { expect(@view.save_code(:actions, '@say_hello = "Hello There"')).to eq(true) }
    end

    context 'update' do
      it { expect(@view.change_name('other_name')).to eq(true) }
      it '' do 
        @view.name = 'other_name'
        expect(@view.change_name('test_index')).to eq(true)
      end
    end
      
    context 'uninstall' do
      it '' do
        @view.name = 'test_index'
        expect(@view.uninstall).to eq(true)
      end
    end
  end

  context 'view js' do
    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET", format_result: "JS")
      @view.install
    end

    context 'output' do
      it { expect(@view.output_remote_js).to eq("// test_index javascript Erb template\n") }
    end

    context 'save' do
      it { expect(@view.save_code(:remote_js, "alert('remote js has been saved')\n")).to eq(true) }
    end

    after(:each) do
      @view.uninstall
    end
  end
end