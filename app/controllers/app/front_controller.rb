module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'
    def index
    end
    
    def message
      @message = KepplerContactUs::Message.new
    end
  end
end
