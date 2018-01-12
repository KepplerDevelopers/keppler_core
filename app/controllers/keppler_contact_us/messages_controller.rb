#Generado con Keppler.
require_dependency "keppler_contact_us/application_controller"

module KepplerContactUs
  class MessagesController < Admin::AdminController
    before_filter :authenticate_user!, except: [:create]
    layout 'admin/layouts/application', except: [:new]
    load_and_authorize_resource except: [:create]
    before_action :set_message, only: [:show, :edit, :update, :destroy]
    before_action :show_history, only: [:index]

    # GET /messages
    def index
      @q = Message.ransack(params[:q])
      messages = @q.result(distinct: true)
      @objects = messages.page(@current_page)
      @total = messages.size

      if !@objects.first_page? && @objects.size.zero?
        redirect_to(
          posts_path(page: @current_page.to_i.pred, search: @query)
        )
      end
    end

    # GET /messages/1
    def show
      message = Message.find_by(id: params[:id])
      message.update(read: true) unless message.read
    end

    # POST /messages
    def create
      @message = Message.new(message_params)
      if verify_recaptcha(model: @message, timeout: 10, message: "Oh! It's error with reCAPTCHA!") and @message.save
        ContactMailer.contact(@message).deliver_now
        redirect_to KepplerContactUs.redirection, notice: t('keppler.messages.sent_message')
      else
        redirect_to KepplerContactUs.redirection, alert: t('keppler.messages.error_message')
      end
    end

    # DELETE /messages/1
    def destroy
      @message.destroy
      redirect_to messages_url, notice: actions_messages(@message)
    end

    def destroy_multiple
      Message.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        messages_path(page: @current_page, search: @query),
        notice: actions_messages(Message.new)
      )
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:name, :subject, :email, :content, :read)
    end

    def show_history
      get_history(Message)
    end
  end
end
