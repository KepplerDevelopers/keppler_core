require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::NoEditArea, type: :services do

  context 'no edit area' do
    let(:fixture) { "#{Rails.root}/spec/fixtures/keppler_frontend/live_editor/" }

    let(:file_original) { "#{fixture}/test_index_original.html" }

    let(:file_editor) { "#{fixture}/test_index_editor.html" }

    before(:each) do
      @no_edit_area = KepplerFrontend::LiveEditor::NoEditArea.new(file_original)
    end

    context 'get no edit area ids' do
      let(:no_edit_areas) { @no_edit_area.ids }

      it { expect(no_edit_areas).to eq([["area_one"], ["area_two"], ["area_three"]]) }
    end

    context 'get no edit areas' do
      let(:no_edit_areas) do
        ids = @no_edit_area.ids
        @no_edit_area.code_no_edit(ids)
      end

      it { expect(no_edit_areas).to be_a(Array) }
      it { expect(no_edit_areas.count).to eq(3) }
      it { expect(no_edit_areas[0]).to eq(["area_one", ["  <keppler-no-edit id='area_one'>\n", "    <%= 'area_one' %>\n", "  </keppler-no-edit>\n"]]) }
      it { expect(no_edit_areas[1]).to eq(["area_two", ["  <keppler-no-edit id='area_two'>\n", "    <%= 'area_two' %>\n", "  </keppler-no-edit>\n"]]) }
      it { expect(no_edit_areas[2]).to eq(["area_three", ["  <keppler-no-edit id='area_three'>\n", "    <%= 'area_three' %>\n", "  </keppler-no-edit>\n"]]) }
    end

    context 'merge no edit areas' do
      let(:merge_no_edit_areas) do
        @no_edit_area.merge_to(file_editor)
      end

      it { expect(merge_no_edit_areas).to eq(["<keppler-header>\n", "  <h1>Header</h1>\n", "  <keppler-no-edit id='area_one'>\n", "    <%= 'area_one' %>\n\n", "  </keppler-no-edit>\n", "</keppler-header>\n", "<keppler-view ='test_index'>\n", "  <h1>Test Index</h1>\n", "  <keppler-no-edit id='area_two'>\n", "    <%= 'area_two' %>\n\n", "  </keppler-no-edit>\n", "</keppler-view>\n", "<keppler-footer>\n", "  <h1>Footer</h1>\n", "  <keppler-no-edit id='area_three'>\n", "    <%= 'area_three' %>\n\n", "  </keppler-no-edit>\n", "</keppler-footer>"]) }
    end
  end
end