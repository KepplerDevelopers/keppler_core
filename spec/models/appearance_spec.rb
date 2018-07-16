require 'rails_helper'
require 'byebug'

RSpec.describe Appearance, type: :model do

  context 'database' do
    context 'columns' do
      it { should have_db_column(:image_background).of_type(:string) }
      it { should have_db_column(:theme_name).of_type(:string) }
      it { should have_db_column(:setting_id).of_type(:string) }
    end

    context 'assosiations' do
      it { should belong_to(:setting) }
    end
  end
end