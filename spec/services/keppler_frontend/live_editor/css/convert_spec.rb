require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::LiveEditor::Css::Convert, type: :services do

  context 'css convert' do

    before(:each) do
      @input_css = ".title {\n  background-color: silver; }\n  .title h1 {\n    color: red; }\n"
      @input_scss = ".title {\n  background-color: silver;\n\n  h1 {\n    color: red;\n  }\n}"
      @view = create(:keppler_frontend_views, method: "GET")
      @view.install
      urls = KepplerFrontend::Urls::Assets.new
      core_css_app = urls.core_assets('stylesheets', 'app')
      @css_url = "#{core_css_app}/views/#{@view.name}.scss"
      out_file = File.open(@css_url, "w")
      out_file.puts(@input_scss);
      out_file.close
    end

    context 'convert css to scss' do     
      let(:convert) { KepplerFrontend::LiveEditor::Css::Convert.new(@input_css) } 
      it { expect(convert.to_scss).not_to eq(nil) }
      it { expect(convert.to_scss).to eq(@input_scss) }
    end

    context 'convert scss to css' do     
      let(:convert) do
        KepplerFrontend::LiveEditor::Css::Convert.new(@css_url)
      end
      it { expect(convert.to_css).not_to eq(nil) }
      it { expect(convert.to_css).to eq(@input_css) }
    end 

    after(:each) do
      @view.uninstall
    end 
  end
end