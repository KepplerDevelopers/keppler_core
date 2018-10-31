require 'rails_helper'
require 'htmlbeautifier'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::HtmlHandler, type: :services do

  context 'html handler' do
    let(:fixture) { "#{Rails.root}/spec/fixtures/keppler_frontend/live_editor/" }

    let(:front) { KepplerFrontend::Urls::Front.new }

    let(:view_original) do 
      view = File.read(front.view(@view.name)).split("\n") 
      save = File.open(front.view(@view.name), "w")
      view.insert(1, "  <keppler-no-edit id=\"area_two\">\n    <%= area_two %>\n  </keppler-no-edit>\n")
      save.puts(view.join("\n"))
      save.close
      view.insert(0, "<keppler-header></keppler-header>\n")
      view.insert(view.count, "\n<keppler-footer></keppler-footer>")
      view.join("\n")
    end

    let(:file_editor) { "<keppler-header>\n<h1>Header Edited</h1>\n</keppler-header>\n<keppler-view id=\"test_index\">\n  <h1>Test Index Edited</h1>\n  <keppler-no-edit id=\"area_two\">\n    <p>area_two</p>\n  </keppler-no-edit>\n</keppler-view>\n\n<keppler-footer>\n<h1>Footer Edited</h1>\n</keppler-footer>" }
    
    let(:file_editor_has_been_moved) { "<keppler-header>\n<h1>Header Edited</h1>\n  <keppler-no-edit id=\"area_two\">\n    <p>area_two</p>\n  </keppler-no-edit>\n</keppler-header>\n<keppler-view id=\"test_index\">\n  <h1>Test Index Edited</h1>\n</keppler-view>\n\n<keppler-footer>\n<h1>Footer Edited</h1>\n</keppler-footer>" }

    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET")
      @view.install
      @layout_original = File.read(front.layout)
      @html_handler = KepplerFrontend::LiveEditor::HtmlHandler.new(@view.name)
      @view_no_edit = KepplerFrontend::LiveEditor::NoEditArea.new(view_original.split("\n"))
    end

    context 'save a area' do      
      before(:each) do
        html_processed = @view_no_edit.merge_to(file_editor.split("\n"))
        @html_handler.save_area('view', html_processed)
        @view_result = File.readlines(front.view(@view.name))
      end

      it { expect(@view_result).to eq(["<keppler-view id=\"test_index\">\n", "  <!-- Keppler Section -->\n", "  <h1>Test Index Edited</h1>\n", "  <keppler-no-edit id=\"area_two\">\n", "    <%= area_two %>\n", "  </keppler-no-edit>\n", "</keppler-view>"]) }
    end

    context 'save' do      
      before(:each) do
        @html_handler.save(file_editor)
        @view_layout = File.readlines(front.layout)
        @view_result = File.readlines(front.view(@view.name))
        # byebug
      end

      it { expect(@view_result).to eq(["<keppler-view id=\"test_index\">\n", "  <!-- Keppler Section -->\n", "  <h1>Test Index Edited</h1>\n", "  <keppler-no-edit id=\"area_two\">\n", "    <%= area_two %>\n", "  </keppler-no-edit>\n", "</keppler-view>"]) }
      it { expect(@view_layout).to eq(["<!DOCTYPE html>\n", "<html id=\"keppler-html\">\n", "  <head>\n", "    <%= set_head %>\n", "  </head>\n", "  <body id=\"keppler-editor\">\n", "    <keppler-header>\n", "      <!-- Keppler Section -->\n", "      <h1>Header Edited</h1>\n", "    </keppler-header>\n", "    <%= yield %>\n", "    <keppler-footer>\n", "      <!-- Keppler Section -->\n", "      <h1>Footer Edited</h1>\n", "    </keppler-footer>\n", "  </body>\n", "  <%= keppler_editor %>\n", "</html>"]) }
    end

    context 'save when a element has beed moved' do      
      before(:each) do
        @html_handler.save(file_editor_has_been_moved)
        @view_layout = File.readlines(front.layout)
        @view_result = File.readlines(front.view(@view.name))
      end

      it { expect(@view_result).to eq(["<keppler-view id=\"test_index\">\n", "  <!-- Keppler Section -->\n", "  <h1>Test Index Edited</h1>\n", "</keppler-view>"]) }
      it { expect(@view_layout).to eq(["<!DOCTYPE html>\n", "<html id=\"keppler-html\">\n", "  <head>\n", "    <%= set_head %>\n", "  </head>\n", "  <body id=\"keppler-editor\">\n", "    <keppler-header>\n", "      <!-- Keppler Section -->\n", "      <h1>Header Edited</h1>\n", "      <keppler-no-edit id=\"area_two\">\n", "        <%= area_two %>\n", "      </keppler-no-edit>\n", "    </keppler-header>\n", "    <%= yield %>\n", "    <keppler-footer>\n", "      <!-- Keppler Section -->\n", "      <h1>Footer Edited</h1>\n", "    </keppler-footer>\n", "  </body>\n", "  <%= keppler_editor %>\n", "</html>"]) }
    end

    after(:each) do
      @view.uninstall
      out_file = File.open(front.layout, "w")
      out_file.puts(@layout_original);
      out_file.close
    end
  end
end