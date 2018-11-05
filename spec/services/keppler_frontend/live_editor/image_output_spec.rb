require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::ImagesHandler, type: :services do

  context 'image handler' do
    context 'output' do
        before(:each) { @image_handler = KepplerFrontend::LiveEditor::ImagesHandler.new }

        it { expect(@image_handler.output).not_to eq(nil) }
        it { expect(@image_handler.output).not_to be_a(String) }
        it { expect(@image_handler.output).not_to eq([]) }
        it { expect(@image_handler.output).to be_a(Array) }
        it { expect(@image_handler.output.count).to eq(1)  }
    end
  end
end


