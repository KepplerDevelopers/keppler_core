require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Urls::Front, type: :services do

  context 'front urls' do

    before(:all) do
      @root = KepplerFrontend::Urls::Roots.new
      @front = KepplerFrontend::Urls::Front.new
    end

    context 'view url' do
      let(:result) {"#{@root.rocket_root}/app/views/keppler_frontend/app/frontend/test_index.html.erb"} 

      it { expect(@front.view('test_index')).to eq(result) }
    end

    context 'front urls' do
      let(:result) {"#{@root.rocket_root}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"}

      it { expect(@front.layout).to eq(result) }
    end
  end
end