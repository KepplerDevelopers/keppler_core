module App
  # FrontsController
  class FrontController < AppController
    layout 'layouts/templates/application'

    def index
      @message = KepplerContactUs::Message.new
    end

    def test_mailer
      @client = KepplerContactUs::Message.new(
        name: 'Anyelo',
        email: 'anyelopetit@gmail.com',
        subject: 'Asunto',
        content: 'Contenido'
      )
    end

  end
end
