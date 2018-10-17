require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::View, type: :model do

  context 'database' do
    context 'columns' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:url).of_type(:string) }
      it { should have_db_column(:method).of_type(:string) }
      it { should have_db_column(:format_result).of_type(:string) }
      it { should have_db_column(:active).of_type(:boolean) }
    end

    context 'assosiations' do
      it { should have_many(:view_callbacks) }
    end

    context 'render live editor' do
      it 'give data for live editor' do
        view = create(:keppler_frontend_views, method: "get")
        editor = view.live_editor_render
        expect(editor.count).to eq(5)
        expect(editor[:view_id]).to be_a(Numeric)
        expect(editor[:view_name]).to be_a(String)
        # expect(editor[:css_style]).not_to eq(nil)
      end
    end
  end
end