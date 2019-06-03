require 'rails_helper'
require 'byebug'

RSpec.describe Rocket, type: :model do
  let(:core_depending) { Rocket.core_depending }
  let(:rocket) { Rocket.new('keppler_capsules') }

  context 'Check if a rocket does not have permission to uninstall' do
    it 'show rocket name' do 
      expect(rocket.name).to eq('keppler_capsules')
    end

    it 'show array with rockets that do not have permission to be uninstalled' do
      expect(core_depending).to eq(['keppler_frontend', 'keppler_ga_dashboard'])
    end
  end
end