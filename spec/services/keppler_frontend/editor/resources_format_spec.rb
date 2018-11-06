require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Editor::ResourcesFormat, type: :services do

  context 'Resources Format' do
    let(:root) { KepplerFrontend::Urls::Roots.new }
    let(:fixture) { "#{root.keppler_root}/spec/fixtures/keppler_frontend/editor" }
    let(:images) { "#{root.rocket_root}/app/assets/images/keppler_frontend/app" }
    let(:html) { "#{root.rocket_root}/app/assets/html/keppler_frontend/views" }

    before(:each) do
      @resources = KepplerFrontend::Editor::Resources.new
      FileUtils.mv("#{fixture}/test.png", "#{images}/test.png")
      FileUtils.mv("#{fixture}/test.html", "#{html}/test.html")
    end

    context 'output with app container' do
      before(:each) do
        @resources = KepplerFrontend::Editor::ResourcesFormat.new(@resources.list.last[:name], 'app')
      end

      it { expect(@resources.output).to be_a(Hash) }
      it { expect(@resources.output.count).to eq(11) }
      it { expect(@resources.output[:name]).to eq("test.png") }
      it { expect(@resources.output[:format]).to eq("png") }
    end

    context 'output with view container' do
      before(:each) do
        @resources = KepplerFrontend::Editor::ResourcesFormat.new(@resources.custom_list('views').last[:name], 'views')
      end

      it { expect(@resources.output).to be_a(Hash) }
      it { expect(@resources.output.count).to eq(11) }
      it { expect(@resources.output[:name]).to eq("test.html") }
      it { expect(@resources.output[:format]).to eq("html") }
    end

    after(:each) do
      FileUtils.mv("#{images}/test.png", "#{fixture}/test.png")
      FileUtils.mv("#{html}/test.html", "#{fixture}/test.html")
    end
  end
end