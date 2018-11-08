require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Urls::Assets, type: :services do

  context 'assets urls' do

    before(:all) do
      @root = KepplerFrontend::Urls::Roots.new
      @assets = KepplerFrontend::Urls::Assets.new
    end

    context 'core urls' do
      let(:result) {"#{@root.rocket_root}/app/assets/images/keppler_frontend/app"} 

      it { expect(@assets.core_assets('images', 'app')).to eq(result) }
    end

    context 'front urls' do
      let(:result) {"/assets/keppler_frontend/app/image.jpg"} 

      it { expect(@assets.front_assets('image.jpg')).to eq(result) }
    end
  end
end