require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Editor::FileFormat, type: :services do

  context 'File Format' do
    let(:root) { KepplerFrontend::Urls::Roots.new }
    let(:fixture) { "#{root.keppler_root}/spec/fixtures/keppler_frontend/editor" }
    let(:html) { "#{root.rocket_root}/app/assets/html/keppler_frontend/views" }

    before(:each) do
      FileUtils.mv("#{fixture}/test.png", "#{html}/test.png")
      FileUtils.mv("#{fixture}/test.html", "#{html}/test.html")
      @file_format = KepplerFrontend::Editor::FileFormat.new
      @formats = ['.jpg', '.jpeg', '.png', '.svg', '.gif', '.tiff', '.bmp', '.mp3',
                  '.eot', '.otf', '.ttf', '.woff', '.woff2', '.mp4', '.mpeg', '.webm', '.m4v',
                  '.html', '.js', '.coffee', '.json', '.css', '.scss', 'sass'
                 ]
    end

    context 'validate file by format' do
      it 'test formats' do
        @formats.each do |f|
          expect(@file_format.validate("test.#{f}")).to eq(true)
        end
        expect(@file_format.validate("test.xyz")).to eq(false)
      end
    end

    after(:each) do
      FileUtils.mv("#{html}/test.png", "#{fixture}/test.png")
      FileUtils.mv("#{html}/test.html", "#{fixture}/test.html")
    end
  end
end