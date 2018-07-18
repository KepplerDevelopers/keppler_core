require 'rails_helper'
require 'byebug'

RSpec.describe Role, type: :model do
  let(:role) { create(:role) }
  let(:permission) { create(:permission, ) }

  context 'database' do
    context 'columns' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:position).of_type(:integer) }
      it { should have_db_column(:deleted_at).of_type(:string) }
    end

    context 'assosiations' do
      it { should have_many(:permissions) }
      it { should have_and_belong_to_many(:users) }
      it { should belong_to(:resource) }
    end

    context 'validates' do
      it 'validates uniqueness of name' do
        role = build_stubbed(:role, name: 'keppler_admin')
        expect(role).to be_invalid
      end
    end

    context 'class fuctions' do
      it { expect(Role.search_field).to eq(:name_cont) }
    end

    context 'instance fuctions' do
      it { expect(role.permissions?).to eq(false) }
      it { expect(role.all_permissions).to eq(nil) }

      it 'first permission to module' do
        role.first_permission('Script', 'index')
        expect(role.action?('Script', 'index')).to eq(true)
      end

      it 'permission to module is false' do
        role.first_permission('Script', 'index')
        role.toggle_actions('Script', 'index')
        expect(role.action?('Script', 'index')).to eq(false)
      end

      it 'quit permission to module is true' do
        role.first_permission('Script', 'index')
        role.toggle_actions('Script', 'index')
        role.toggle_actions('Script', 'index')
        expect(role.action?('Script', 'index')).to eq(true)
      end

      it 'have a some permission?' do
        role.first_permission('User', 'index')
        expect(role.permissions?).to eq(true)
      end

      it 'have not a some permission?' do
        expect(role.permissions?).to eq(false)
      end

      it 'have permissions to' do
        role.first_permission('Script', 'index')
        expect(role.permission_to('Script')).to eq(true)
      end
    end
  end
end
