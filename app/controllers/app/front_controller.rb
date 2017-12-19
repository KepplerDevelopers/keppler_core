module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    before_action :set_message
    # require 'whois'
    # require 'whois-parser'

    def index
      @proyect = Proyect.all
    end

    def web
      @webs = Web.all
      @proyect = Proyect.last(3)

    end

    def briefing
      @briefing = Briefing.new
    end

    def aboutus
    end

    def search

      # def availability(domain)
      #   record = Whois.whois(domain)
      #   parser = record.parser
      #   if parser.available?
      #     puts "The domain #{domain} is available"
      #   else
      #     puts "The domain #{domain} is not available"
      #   end
      #
      #   puts "Esta registrado..." if parser.registered?
      # end
      #
      # dom = gets.chomp
      # availability(dom)
    end

    def success
      @web = Proyect.where(service_type: "Web")
      @social = Proyect.where(service_type: "Social Ads")
      @google = Proyect.where(service_type: "Google Adwords")
      @branding = Proyect.where(service_type: "Branding")

    end

    def success_ej
      @proyect = Proyect.find(params[:id])
    end

    def services
      @message = KepplerContactUs::Message.new
    end

    def notices
    end

    def branding
      @brandings = Branding.all
      @brands = Proyect.all
    end

    def digital
      @marketings = Marketing.all
      @proyect = Proyect.last(3)
    end

    def show_more
      @type = params[:type]

      if params[:type].eql?('web')
        @web = Proyect.where(service_type: "Web").first(8)
      elsif params[:type].eql?('social')
        @social = Proyect.where(service_type: "Social Ads").first(8)
      elsif params[:type].eql?('google')
        @google = Proyect.where(service_type: "Google Adwords").first(8)
      elsif params[:type].eql?('branding')
        @branding = Proyect.where(service_type: "Branding").first(8)
      end
    end

    private

    def set_message
      @message = KepplerContactUs::Message.new
    end

  end
end
