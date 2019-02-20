require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::CallbackFunction, type: :model do

  context 'database' do
    context 'columns' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:description).of_type(:string) }
    end

    context 'Callback user_authenticate exist' do
      let(:all_callbacks) { KepplerFrontend::CallbackFunction.all }

      it { expect(all_callbacks.count).to eq(1) }
      it { expect(all_callbacks.first.name).to eq("user_authenticate") }
    end
  end
end