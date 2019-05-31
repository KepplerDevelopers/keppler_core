require 'rails_helper'
require 'byebug'

RSpec.describe RocketPolicy do
  let(:user) { User.first }
  let(:keppler_frontend) { Rocket.new('keppler_frontend') }
  let(:keppler_capsule) { Rocket.new('keppler_capsule') }
  let(:rocket_without_permissions) { RocketPolicy.new(user, keppler_frontend) }
  let(:rocket_with_permissions) { RocketPolicy.new(user, keppler_capsule) }

  context 'Check if a rocket does not have permission to uninstall' do
    it 'can be uninstalled' do
      expect(rocket_with_permissions.uninstall?).to eq(true)
    end

    it 'can´t be uninstalled' do
      expect(rocket_without_permissions.uninstall?).to eq(false)
    end
  end
end