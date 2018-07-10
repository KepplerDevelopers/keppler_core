require 'rails_helper'
require 'byebug'

RSpec.describe Script, type: :model do
  let(:script) { create(:script) }

  let(:request) do
    Request = Struct.new(:url)
    request = Request.new("www.example.com")
  end

  context 'database' do
    context 'columns' do
      it { should have_db_column(:name).of_type(:string) }
      it { should have_db_column(:position).of_type(:integer) }
      it { should have_db_column(:script).of_type(:text) }
      it { should have_db_column(:url).of_type(:string) }
    end
  end

  context 'class fuctions' do
    it 'get a script' do
      object = create(:script, url: "www.example.com")
      script = Script.get_script(request)
      expect(script).to eq(object)
    end

    it 'search param' do
      expect(Script.search_field).to eq(:name_or_script_cont)
    end
  end

  context 'concerns' do
    it 'clone record' do
      original = script
      duplicated = Script.clone_record(original.id)
      expect(duplicated.url).to eq(original.url)
      expect(duplicated.name).to eq(original.name)
      expect(duplicated.script).to eq(original.script)
    end
  end
end
