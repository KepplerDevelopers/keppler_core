require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Editor::Resources, type: :services do

  context 'Resources' do
    let(:root) { KepplerFrontend::Urls::Roots.new }
    let(:fixture) { "#{root.keppler_root}/spec/fixtures/keppler_frontend/editor" }
    let(:images) { "#{root.rocket_root}/app/assets/images/keppler_frontend/app" }
    let(:html) { "#{root.rocket_root}/app/assets/html/keppler_frontend/views" }

    before(:each) do
      @resources = KepplerFrontend::Editor::Resources.new
      FileUtils.mv("#{fixture}/test.png", "#{images}/test.png")
      FileUtils.mv("#{fixture}/test.html", "#{html}/test.html")
    end

    context 'list' do
      let(:content) { @resources.list.map { |r| r[:name] } }

      it { expect(@resources.list).not_to eq(false) }
      it { expect(@resources.list).not_to eq(nil) }
      it { expect(@resources.list.count).not_to eq(0) }
      it { expect(@resources.list.last[:name]).to eq("test.png") }
      it { expect(@resources.list).to be_a(Array) }
      it { expect(@resources.list.first).to be_a(Hash) }
    end

    context 'custom list' do
      context 'views' do
        it { expect(@resources.custom_list('views')).not_to eq(false) }
        it { expect(@resources.custom_list('views')).to be_a(Array) }
        it { expect(@resources.custom_list('views').first).to be_a(Hash) }
        it { expect(@resources.custom_list('views').first[:format]).to eq('html') }
        it { expect(@resources.custom_list('views').last[:name]).to eq("test.html") }
      end
    end

    after(:each) do
      FileUtils.mv("#{images}/test.png", "#{fixture}/test.png")
      FileUtils.mv("#{html}/test.html", "#{fixture}/test.html")
    end
  end
end