require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Utils::YmlHandler, type: :services do

  before(:all) do
    @config = KepplerFrontend::Urls::Config.new
    @yml_original = File.read(@config.yml('views'))
  end

  before(:each) do
    @config = KepplerFrontend::Urls::Config.new
    @view = create(:keppler_frontend_views, method: "GET")
    @views = KepplerFrontend::View.all
    @yml = KepplerFrontend::Utils::YmlHandler.new('views', @views)
  end

  context 'update' do
    let(:update_yml) { @yml.update }
    let(:database) { KepplerFrontend::View.all.map { |v| v.name } }
    let(:yml) { YAML.load_file(@config.yml('views')).map { |v| v['name'] } }

    it { expect(update_yml).to eq(true) }
    it { expect(yml).to eq(database) }
  end

  context 'reload' do
    let(:reload_yml) { @yml.reload }
    let(:database) { KepplerFrontend::View.all.map { |v| v.name } }
    let(:yml) { YAML.load_file(@config.yml('views')).map { |v| v['name'] } }

    it { expect(reload_yml).to eq(true) }
    it { expect(yml).to eq(database) }
  end

  after(:all) do
    File.write(@config.yml('views'), @yml_original)
  end
  
end