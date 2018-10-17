require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::Editor, type: :services do

  context 'database' do
    context 'assosiations' do
      it { should have_many(:view_callbacks) }
    end
  end
end