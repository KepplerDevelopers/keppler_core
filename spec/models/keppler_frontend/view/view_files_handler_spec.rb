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

    context 'update' do
      it { expect(@view.change_name('other_name')).to eq(true) }
      it '' do 
        @view.name = 'other_name'
        expect(@view.change_name('test_index')).to eq(true)
      end
    end
      
    context 'uninstall' do
      it '' do
        @view.name = 'test_index'
        expect(@view.uninstall).to eq(true)
      end
    end
  end
end