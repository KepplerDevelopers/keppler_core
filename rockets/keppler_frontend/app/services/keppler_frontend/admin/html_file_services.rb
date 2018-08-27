module KepplerFrontend
  module Admin
    # HtmlFileService
    class HtmlFileService

      def initialize(view)
        @view = view
      end

      def url_front
        "#{Rails.root}/rockets/keppler_frontend"
      end

      def install_html
        out_file = File.open("#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb", "w")
        out_file.puts("<h1> #{name} template </h1>");
        out_file.close
        true
      end

      def uninstall_html
        file = "#{url_front}/app/views/keppler_frontend/app/frontend/#{name}.html.erb"
        File.delete(file) if File.exist?(file)
        true
      end
    end
  end
end
