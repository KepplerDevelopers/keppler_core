module KepplerFrontend
  # AppController -> Controller out the back-office
  class App::AppController < ::ApplicationController
    layout 'app/layouts/application'
    skip_before_action :verify_authenticity_token
    before_action :set_locale
    before_action :set_metas
    before_action :set_analytics
    before_action :grapes_info

    include KepplerCapsules::Concerns::Lib
    def set_metas
      @theme_color = nil
      # Descomentar el modelo que exista depende del proyecto
      # @post = KepplerBlog::Post.find(params[:id])
      # @product = Product.find(params[:id])
      # @setting = Setting.includes(:social_account).first
      @meta = MetaTag.get_by_url(request.url)
      @social = @setting.social_account
      @meta_title = MetaTag.title(@post, @product, @setting)
      @meta_description = MetaTag.description(@post, @product, @setting)
      @meta_image = MetaTag.image(request, @post, @product, @setting)
      @meta_locale = @locale.eql?('es') ? 'es_VE' : 'en_US'
      @meta_locale_alternate = @locale.eql?('es') ? 'en_US' : 'es_VE'
      @country_code = @locale.eql?('es') ? 'VE' : 'US'
    end

    private

    ###################################  Grapes Js Functions (Begin) ###################################

    def grapes_info      
      if params[:editor] && controller_name.eql?('frontend') && !action_name.eql?('keppler')
        gon.css_style = set_css_style
        gon.images_assets = set_assets
        gon.components = set_components
      end
    end

    def set_css_style
      lines = File.readlines("#{url_front}/app/assets/stylesheets/keppler_frontend/app/views/#{action_name}.scss")
      lines = lines.select { |l| !l.include?("//") }
      lines.join
    end

    def set_assets
      images = Dir["#{url_front}/app/assets/images/keppler_frontend/app/*"]
      images_containers = []
      images.each do |image|
        images_containers << { type: 'image', src: "/assets/keppler_frontend/app/#{image.split('/').last}" }
      end
      return images_containers
    end

    def set_components
      list_components = []
      components = Dir["#{url_front}/app/assets/html/keppler_frontend/app/**/*.html"]
      components.each do |component|
        lines = File.readlines(component)
        begin_idx = 0
        end_idx = 0
        lines.each do |idx|
          begin_idx = lines.find_index(idx) if idx.include?("<script>")
          end_idx = lines.find_index(idx) if idx.include?("</script>")
        end
        lines = lines[begin_idx+1..end_idx-1]
        list_components << "[#{lines.join('')}]".gsub!("\n", "")
      end
      list_components
    end

    ###################################  Grapes Js Functions (End) ###################################
    
    def rocket(name, model)
      name = name.singularize.downcase.capitalize
      model = model.singularize.downcase.capitalize
      "Keppler#{name}::#{model}".constantize
    end

    def set_locale
      if params[:locale]
        @locale = I18n.locale = params[:locale]
      elsif request.env['HTTP_ACCEPT_LANGUAGE']
        request_lang = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/)[0]
        @locale = I18n.locale = request_lang.eql?('es') ? 'es' : 'en'
      end
    end

    def default_url_options(options = {})
      logger.debug "default_url_options is passed options: #{options.inspect}\n"
      { locale: I18n.locale }
    end

    def set_analytics
      @scripts = Script.select { |x| x.url == request.env['PATH_INFO'] }
    end

    def url_front
      "#{Rails.root}/rockets/keppler_frontend"
    end
  end
end
