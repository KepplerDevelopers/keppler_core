require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Urls::Config, type: :services do

  context 'assets urls' do

    before(:all) do
      @root = KepplerFrontend::Urls::Roots.new
      @config = KepplerFrontend::Urls::Config.new
    end

    context 'core urls' do
      let(:result) {"#{@root.rocket_root}/config/routes.rb"} 

      it { expect(@config.routes).to eq(result) }
    end

    context 'front urls' do
      let(:result) {"#{@root.rocket_root}/config/data/views.yml"} 

      it { expect(@config.yml('views')).to eq(result) }
    end
  end
end