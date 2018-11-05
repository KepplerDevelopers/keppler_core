require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::Editor, type: :services do

  context 'live editor' do
    context 'save' do
      let(:html_code) { "<keppler-header>\n<h1>Header Edited</h1>\n</keppler-header>\n<keppler-view id=\"test_index\">\n  <h1>Test Index Edited</h1>\n  <keppler-no-edit id=\"area_two\">\n    <p>area_two</p>\n  </keppler-no-edit>\n</keppler-view>\n\n<keppler-footer>\n<h1>Footer Edited</h1>\n</keppler-footer>" }
      let(:css_code) { ".h1 { color: red; }" }
      let(:front) { KepplerFrontend::Urls::Front.new }

      before(:each) do
        @layout_original = File.read(front.layout)
        @view = create(:keppler_frontend_views, method: "GET")
        @view.install
        @editor = KepplerFrontend::LiveEditor::Editor.new({
          view_id: 1,
          view_name: @view.name
        })
        @editor = @editor.live_editor_save(html_code, css_code)
      end    

      it { expect(@editor).to eq(true) }

      after(:each) do
        @view.uninstall
        out_file = File.open(front.layout, "w")
        out_file.puts(@layout_original);
        out_file.close
      end 
 
    end
  end
end


