module KepplerContactUs
  module Admin
    class MessageMailer < KepplerContactUs::ApplicationMailer

      def send_mail(message)
        message_params(message)
        mail(
          from: @message.from_email,  
          to: @message.to_emails.split(', '),
          subject: @message.subject
        )
      end

      private

      def message_params(message)
        @message = message
        # @category = Category.find(message.category).name_en
        # @product = Product.find(message.product_id)
        # @image = message.product.images.first.url if message.product.images.first.url
        # attachments.inline[@image] = File.read("#{Rails.root}/public#{@image}") if @image
      end
    end
  end
end
