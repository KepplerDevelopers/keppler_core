require 'rails_helper'
require 'byebug'

RSpec.describe Permission, type: :model do

  context 'database' do
    context 'columns' do
      it { should have_db_column(:modules).of_type(:jsonb) }
      it { should have_db_column(:role_id).of_type(:integer) }
    end

    context 'assosiations' do
      it { should belong_to(:role) }
    end
  end
end