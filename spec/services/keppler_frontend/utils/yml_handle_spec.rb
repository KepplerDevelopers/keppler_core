require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Utils::YmlHandler, type: :services do

  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
    @views = KepplerFrontend::View.all
    @yml = KepplerFrontend::Utils::YmlHandler.new('views', @views)
    @config = KepplerFrontend::Urls::Config.new
  end

  context 'update' do
    before(:each) { @update_yml = @yml.update }
    let(:database) { KepplerFrontend::View.all.map { |v| v.name } }
    let(:yml) { YAML.load_file(File.join(@config.yml('views'))).map { |v| v["name"] } }

    it { expect(@update_yml).to eq(true) }
    it { expect(yml).to eq(database) }
  end

  context 'reload' do
    before(:each) { @reload_yml = @yml.reload }
    let(:database) { KepplerFrontend::View.all.map { |v| v.name } }
    let(:yml) { YAML.load_file(File.join(@config.yml('views'))).map { |v| v["name"] } }

    it { expect(@reload_yml).to eq(true) }
    it { expect(yml).to eq(database) }
  end

  after(:each) do
    @view.destroy
    @views = KepplerFrontend::View.all
    @yml = KepplerFrontend::Utils::YmlHandler.new(@views)
    @yml.update
  end
end