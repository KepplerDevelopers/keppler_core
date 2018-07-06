require 'rails_helper'
require 'byebug'

RSpec.describe Customize, type: :model do

  context 'database' do
    context 'columns' do
      it { should have_db_column(:file).of_type(:string) }
      it { should have_db_column(:installed).of_type(:boolean) }
    end
  end

  context 'class fuctions' do
    it { expect(Customize.search_field).to eq(:file_cont) }
  end

  context 'instance fuctions' do
    it 'set "Keppler Default" if file is nil' do
      theme = create(:customize)
      expect(theme.name).to eq('Keppler Default')
    end
  end
end