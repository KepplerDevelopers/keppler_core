require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Utils::CodeSearch, type: :services do

  context 'code search' do

    before(:all) do
      urls = KepplerFrontend::Urls::Assets.new
      core_app = urls.core_assets('html', 'app')
      component = Dir["#{core_app}/**/*.html"].first
      lines = File.readlines(component)
      @find = KepplerFrontend::Utils::CodeSearch.new(lines)
    end

    context 'find between a range of lines' do
      let(:find_section) { @find.search_section('<script>', '</script>') }

      it { expect(find_section).to be_a(Array) }
      it { expect(find_section.count).to eq(2) }
      it { expect(find_section[0]).to be < (find_section[1]) }
    end

    context 'find a lines' do
      let(:find_section) { @find.search_line('<script>') }

      it { expect(find_section).to be_a(Numeric) }
    end
  end
end