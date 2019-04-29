require 'rails_helper'
require 'byebug'

RSpec.describe Admin::GitHandler, type: :services do

  context 'Git Handler' do
    let(:git) { Admin::GitHandler.new }

    context 'git is installed?' do
      it { expect(git.installed?).to be_in([true, false]) }
    end

    context 'git current branch name' do
      it { expect(git.current_branch).to be_a(String) }
      it { expect(git.current_branch).not_to eq(false) }
    end

    context 'git changes count' do
      it { expect(git.changes_count).to be_a(Hash) }
      it { expect(git.changes_count[:changes]).to be_a(String) }
      it { expect(git.changes_count[:color]).to be_a(String) }
      it { expect(git.changes_count).not_to eq(false) }
    end
  end
end