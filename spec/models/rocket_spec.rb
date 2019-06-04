require 'rails_helper'
require 'byebug'

RSpec.describe Rocket, type: :model do
  let(:core_depending) { Rocket.core_depending }
  let(:rocket) { Rocket.new('keppler_capsules') }

  context 'when the list of rockets is generated' do
    it 'successfully' do
      expect(Rocket.names_list.count).to eq(4)
    end
  end

  context 'when the name of the rocket is shown' do
    it 'successfully' do
      expect(Rocket.parse_name('keppler_frontend')).to eq('frontend')
    end
  end

  context 'Check if a rocket does not have permission to uninstall' do
    it 'show rocket name' do 
      expect(rocket.name).to eq('keppler_capsules')
    end

    it 'show array with rockets that do not have permission to be uninstalled' do
      expect(core_depending).to eq(['keppler_frontend', 'keppler_ga_dashboard'])
    end
  end
end