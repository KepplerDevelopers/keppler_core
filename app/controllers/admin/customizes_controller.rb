module Admin
  # CustomizesController
  class CustomizesController < AdminController
    before_action :set_customize, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /customizes
    def index
      @q = Customize.ransack(params[:q])
      customizes = @q.result(distinct: true)
      @objects = customizes.page(@current_page)
      @total = customizes.size
      if !@objects.first_page? && @objects.size.zero?
        redirect_to customizes_path(page: @current_page.to_i.pred, search: @query)
      end
    end

    # GET /customizes/1
    def show
    end

    # GET /customizes/new
    def new
      @customize = Customize.new
    end

    # GET /customizes/1/edit
    def edit
    end

    # POST /customizes
    def create
      @customize = Customize.new(customize_params)
      @customize.installed = false

      if @customize.save
        redirect_to admin_customizes_path
      else
        render :new
      end
    end

    # PATCH/PUT /customizes/1
    def update
      @customizes = Customize.all
      @customizes.each { |customize| customize.update(installed: false) }
      if @customize.update(customize_params)
        if @customize.installed?
          clear_template
          unzip_template
          install_template_html
          install_template_css
          install_template_images
          install_template_javascript
        else
          clear_template
        end
        redirect_to :back
      else
        render :edit
      end
    end

    def install_default
      @customize = Customize.find(params[:customize_id])
      if !@customize.installed?
        @customizes = Customize.all
        @customizes.each { |customize| customize.update(installed: false) }
        if @customize.update(customize_params)
          clear_template
          redirect_to :back
        else
          render :edit
        end
      else
        redirect_to :back
      end
    end

    def clone
      @customize = Customize.clone_record params[:customize_id]

      if @customize.save
        redirect_to admin_customizes_path
      else
        render :new
      end
    end

    # DELETE /customizes/1
    def destroy
      if @customize.installed?
        clear_template
      end
      @customize.destroy
      redirect_to admin_customizes_path, notice: actions_messages(@customize)
    end

    def destroy_multiple
      Customize.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_customizes_path(page: @current_page, search: @query),
        notice: actions_messages(Customize.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_customize
      @customize = Customize.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customize_params
      params.require(:customize).permit(:file, :installed)
    end

    def show_history
      get_history(Customize)
    end

################################################################################
    def clear_template
      file_name =  Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first
      template_name = file_name.split("/").last if file_name
      names = build_array_html_files_names(template_name, "html")
      system "rails d keppler_front front #{names.join(' ')}"
      system "rm -rf #{Rails.root}/app/views/app/front/"
      system "rm -rf #{Rails.root}/public/templates"
      system "mkdir #{Rails.root}/public/templates"
      clear_assets("#{Rails.root}/app/assets/stylesheets/app/pages")
      clear_assets("#{Rails.root}/app/assets/javascripts/app/pages")
      clear_assets("#{Rails.root}/app/assets/images/img")
      system "touch #{Rails.root}/app/assets/stylesheets/app/pages/_front.scss"
      system "rails g keppler_front front index --skip-migration -f"
    end

    def unzip_template
      system "unzip #{Rails.root}/public/#{@customize.file} -d #{Rails.root}/public/templates"
    end

    def build_array_html_files_names(template_name, extention)
      names = []
      Dir[File.join("#{Rails.root}/public/templates/#{template_name}", '**', '*')].each do |file|
        if File.file?(file)
          name = file.to_s.split("/").last.split(".").first
          extentions = file.to_s.split("/").last.split(".").second
          if extentions.eql?(extention)
            names << name
          end
        end
      end
      return names
    end

    def build_array_assets_files_names(template_name, extention)
      names = []
      Dir[File.join("#{Rails.root}/public/templates/#{template_name}/assets/#{extention}", '**', '*')].each do |file|
        if File.file?(file)
          name = file.to_s.split("/").last
          names << name
        end
      end
      return names
    end

    def install_template_html
      system "rails d keppler_front front index"
      folder = "#{Rails.root}/app/views/app/front"
      template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
      names = build_array_html_files_names(template_name,  "html")
      system "rails g keppler_front front #{names.join(' ')} --skip-migration -f"
      names.each do |name|
        system "rm -rf #{folder}/#{name}.html.haml"
        system "cp #{Rails.root}/public/templates/#{template_name}/#{name}.html #{folder}/#{name}.html"
        system "html2haml #{folder}/#{name}.html #{folder}/#{name}.html.haml"
        system "rm -rf #{folder}/#{name}.html"
      end
    end

    def clear_assets(folder)
      system "rm -rf #{folder}"
      system "mkdir #{folder}"
    end

    def install_template_css
      folder = "#{Rails.root}/app/assets/stylesheets/app/pages"
      clear_assets(folder)
      system "touch #{folder}/_front.scss"
      template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
      names = build_array_assets_files_names(template_name, 'css')
      names.each do |name|
        system "cp #{Rails.root}/public/templates/#{template_name}/assets/css/#{name} #{folder}/_#{name.split('.').first}.scss"
      end
    end

    def install_template_images
      folder = "#{Rails.root}/app/assets/images/img"
      clear_assets(folder)
      template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
      names = build_array_assets_files_names(template_name, 'img')
      names.each do |name|
        system "cp #{Rails.root}/public/templates/#{template_name}/assets/img/#{name} #{folder}/#{name}"
      end
    end

    def install_template_javascript
      folder = "#{Rails.root}/app/assets/javascripts/app/pages"
      clear_assets(folder)
      template_name = Dir[File.join("#{Rails.root}/public/templates", '**', '*')].first.split("/").last
      names = build_array_assets_files_names(template_name, 'js')
      names.each do |name|
        system "cp #{Rails.root}/public/templates/#{template_name}/assets/js/#{name} #{folder}/#{name}"
      end
    end

  end
end
