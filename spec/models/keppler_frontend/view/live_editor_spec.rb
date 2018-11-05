require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::View, type: :model do

  context 'live editor' do
    # context 'render' do
    #   before(:each) do
    #     @view = create(:keppler_frontend_views, method: "GET")
    #     @view.install
    #     @editor = @view.live_editor_render
    #   end    

    #   it { expect(@editor.count).to eq(5) }

    #   it { expect(@editor[:view_id]).not_to eq(nil) }
    #   it { expect(@editor[:view_id]).to be_a(Numeric) }

    #   it { expect(@editor[:view_name]).not_to eq(nil) }
    #   it { expect(@editor[:view_name]).not_to eq('') }
    #   it { expect(@editor[:view_name]).to be_a(String) }

    #   it { expect(@editor[:css_style]).not_to eq(nil) }
    #   it { expect(@editor[:css_style]).not_to eq('') }
    #   it { expect(@editor[:css_style]).to be_a(String) }

    #   it { expect(@editor[:images_assets]).not_to eq(nil) }
    #   it { expect(@editor[:images_assets]).not_to eq([]) }
    #   it { expect(@editor[:images_assets]).to be_a(Array) }

    #   it { expect(@editor[:components]).not_to eq(nil) }
    #   it { expect(@editor[:components]).not_to eq([]) }
    #   it { expect(@editor[:components]).to be_a(Array) }

    #   after(:each) do
    #     @view.uninstall
    #   end   
    # end

    # context 'save' do
    #   let(:html_code) { "<keppler-header>\n<h1>Header Edited</h1>\n</keppler-header>\n<keppler-view id=\"test_index\">\n  <h1>Test Index Edited</h1>\n  <keppler-no-edit id=\"area_two\">\n    <p>area_two</p>\n  </keppler-no-edit>\n</keppler-view>\n\n<keppler-footer>\n<h1>Footer Edited</h1>\n</keppler-footer>" }
    #   let(:css_code) { ".h1 { color: red; }" }
    #   let(:front) { KepplerFrontend::Urls::Front.new }

    #   before(:each) do
    #     @layout_original = File.read(front.layout)
    #     @view = create(:keppler_frontend_views, method: "GET")
    #     @view.install
    #     @result = @view.live_editor_save(html_code, css_code)
    #   end    

    #   it { expect(@result).to eq(true) }

    #   after(:each) do
    #     @view.uninstall
    #     out_file = File.open(front.layout, "w")
    #     out_file.puts(@layout_original);
    #     out_file.close
    #   end 
    # end
  end
end