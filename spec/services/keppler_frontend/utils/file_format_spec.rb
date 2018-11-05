require 'rails_helper'
require 'byebug'

RSpec.describe KepplerFrontend::Utils::FileFormat, type: :services do

  context 'File Format' do
    let(:root) { KepplerFrontend::Urls::Roots.new }
    let(:fixture) { "#{root.keppler_root}/spec/fixtures/keppler_frontend/editor" }
    let(:html) { "#{root.rocket_root}/app/assets/html/keppler_frontend/views" }

    before(:each) do
      @file_format = KepplerFrontend::Utils::FileFormat.new
      @folders = ['audios', 'fonts', 'images', 'videos', 'html', 'javascripts', 'stylesheets']
      @formats = ['.jpg', '.jpeg', '.png', '.svg', '.gif', '.tiff', '.bmp', '.mp3',
                  '.eot', '.otf', '.ttf', '.woff', '.woff2', '.mp4', '.mpeg', '.webm', '.m4v',
                  '.html', '.js', '.coffee', '.json', '.css', '.scss', 'sass'
                 ]
    end

    context 'array of folders' do
      it { expect(@file_format.folders).to be_a(Array) }
      it { expect(@file_format.folders).to eq(@folders) }
    end

    context 'valid formats' do
      it { expect(@file_format.formats).to be_a(Hash) }
      it { expect(@file_format.formats.count).to eq(@folders.count) }
      it { expect(@file_format.formats[:audios]).to eq(['.mp3']) }
      it { expect(@file_format.formats[:fonts]).to eq(['.eot', '.otf', '.ttf', '.woff', '.woff2']) }
      it { expect(@file_format.formats[:images]).to eq(['.jpg', '.jpeg', '.png', '.svg', '.gif', '.tiff', '.bmp']) }
      it { expect(@file_format.formats[:videos]).to eq(['.mp4', '.mpeg', '.webm', '.m4v']) }
      it { expect(@file_format.formats[:html]).to eq(['.html']) }
      it { expect(@file_format.formats[:javascripts]).to eq(['.js', '.coffee', '.json']) }
      it { expect(@file_format.formats[:stylesheets]).to eq(['.css', '.scss', '.sass']) }
    end

    context 'find folder by format file' do
      it 'one by one' do
        @formats.each do |f|
          expect(@file_format.folder("test.#{f}")).to be_a(String)
          expect(@file_format.folder("test.#{f}")).not_to eq('')
          expect(@folders).to include(@file_format.folder("test.#{f}"))
        end
      end
    end

    context 'get file size format' do
      it { expect(@file_format.size(1028)).to be_a(String) }
      it { expect(@file_format.size(1028)).to eq("1.0 Kb") }
    end
  end
end