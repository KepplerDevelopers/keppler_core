require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::CallbackFunction, type: :model do

  context 'database' do
    context 'columns' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:description).of_type(:string) }
    end
  end
end