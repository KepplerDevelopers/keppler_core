#Generado con Keppler.
require_dependency "keppler_contact_us/application_controller"

module KepplerContactUs
  class MessageSettingsController < ApplicationController
    before_filter :authenticate_user!
    layout 'admin/layouts/application'
    load_and_authorize_resource
    before_action :set_message_setting, only: [:edit, :update]

    # GET /message_settings/1/edit
    def edit
      @message_setting = MessageSetting.new unless @message_setting
    end

    # PATCH/PUT /message_settings/1
    def update
      if @message_setting.update(message_setting_params)
        redirect_to edit_message_settings_path(@message_setting), notice: 'Message setting was successfully updated.'
      else
        render :edit
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_message_setting
        @message_setting = MessageSetting.first
      end

      # Only allow a trusted parameter "white list" through.
      def message_setting_params
        params.require(:message_setting).permit(:mailer_to, :mailer_from)
      end
  end
end
