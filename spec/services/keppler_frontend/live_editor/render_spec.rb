require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::Editor, type: :services do

  context 'live editor' do
    context 'render live editor' do
      before(:each) do
        @view = create(:keppler_frontend_views, method: "GET")
        @view.install
        @editor = KepplerFrontend::LiveEditor::Editor.new({
          view_id: 1,
          view_name: @view.name
        })
        @editor = @editor.live_editor_render
      end    

      it { expect(@editor.count).to eq(5) }

      it { expect(@editor[:view_id]).not_to eq(nil) }
      it { expect(@editor[:view_id]).to be_a(Numeric) }

      it { expect(@editor[:view_name]).not_to eq(nil) }
      it { expect(@editor[:view_name]).not_to eq('') }
      it { expect(@editor[:view_name]).to be_a(String) }

      it { expect(@editor[:css_style]).not_to eq(nil) }
      it { expect(@editor[:css_style]).not_to eq('') }
      it { expect(@editor[:css_style]).to be_a(String) }

      it { expect(@editor[:images_assets]).not_to eq(nil) }
      it { expect(@editor[:images_assets]).not_to eq([]) }
      it { expect(@editor[:images_assets]).to be_a(Array) }

      it { expect(@editor[:components]).not_to eq(nil) }
      it { expect(@editor[:components]).not_to eq([]) }
      it { expect(@editor[:components]).to be_a(Array) }

      after(:each) do
        @view.uninstall
      end   
 
    end
  end
end


