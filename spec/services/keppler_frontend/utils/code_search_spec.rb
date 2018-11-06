require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Utils::CodeSearch, type: :services do

  context 'code search' do

    before(:all) do
      urls = KepplerFrontend::Urls::Roots.new
      component = Dir["#{urls.rocket_root}/app/views/layouts/keppler_frontend/app/layouts/application.html.erb"].first
      lines = File.readlines(component)
      @find = KepplerFrontend::Utils::CodeSearch.new(lines)
    end

    context 'find between a range of lines' do
      let(:find_section) { @find.search_section('    <keppler-header>', '    </keppler-header>') }

      it { expect(find_section).to be_a(Array) }
      it { expect(find_section.count).to eq(2) }
      it { expect(find_section[0]).to be < (find_section[1]) }
    end

    context 'find a lines' do
      let(:find_section) { @find.search_line('    <keppler-header>') }

      it { expect(find_section).to be_a(Numeric) }
    end
  end
end