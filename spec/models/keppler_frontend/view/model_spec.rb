require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::View, type: :model do

  context 'database' do
    context 'columns' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:url).of_type(:string) }
      it { should have_db_column(:method).of_type(:string) }
      it { should have_db_column(:format_result).of_type(:string) }
      it { should have_db_column(:active).of_type(:boolean) }
    end

    context 'assosiations' do
      it { should have_many(:view_callbacks) }
    end
  end
end