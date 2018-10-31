require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::View, type: :model do

  context 'View files handler' do

    before(:each) do
      @view = create(:keppler_frontend_views, method: "GET")
    end

    context 'install' do
      it { expect(@view.install).to eq(true) }
    end
  
    context 'uninstall' do
      it { expect(@view.uninstall).to eq(true) }
    end
  end
end