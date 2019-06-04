require 'rails_helper'
require 'byebug'

RSpec.describe Admin::Rockets::Names, type: :services do
  let(:rocket_names) { Admin::Rockets::Names.new }

  context 'when the list of rockets is generated' do
    it 'successfully' do
      expect(rocket_names.list.count).to eq(4)
    end
  end

  context 'when the name of the rocket is shown' do
    it 'successfully' do
      expect(rocket_names.name_format('keppler_frontend')).to eq('frontend')
    end
  end
end