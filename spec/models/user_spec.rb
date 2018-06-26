require 'rails_helper'
require 'byebug'

RSpec.describe User, type: :model do
  context 'database' do
    context 'columns' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:username).of_type(:string) }
      it { should have_db_column(:email).of_type(:string) }
      it { should have_db_column(:encrypted_password).of_type(:string) }
      it { should have_db_column(:deleted_at).of_type(:datetime) }
    end

    context 'validates' do
      it 'validate name' do
        user = build(:user, name: nil)
        expect(user).to be_invalid
      end

      it 'validate email' do
        user = build(:user, email: nil)
        expect(user).to be_invalid
      end

      it 'validate role_ids' do
        user = build(:user, role_ids: nil)
        expect(user).to be_invalid
      end
    end
  end

  context 'class fuctions' do
    it 'user filter by role keppler_admin' do
      query = User.all.order(created_at: :desc).page(1)
      users = User.filter_by_role(query, 'keppler_admin')
      expect(users.shuffle.first.rol).to eq('keppler_admin')
    end
  end
end
