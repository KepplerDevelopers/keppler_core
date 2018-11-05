require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Urls::Assets, type: :services do

  context 'assets urls' do

    before(:all) do
      @root = KepplerFrontend::Urls::Roots.new
    end

    context 'rails root' do
      it { expect(@root.keppler_root).to eq(Rails.root) }
    end

    context 'front urls' do
      let(:result) {"#{@root.keppler_root}/rockets/keppler_frontend"} 

      it { expect(@root.rocket_root).to eq(result) }
    end
  end
end