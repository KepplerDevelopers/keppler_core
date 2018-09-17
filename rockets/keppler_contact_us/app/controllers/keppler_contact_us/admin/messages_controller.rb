require_dependency 'keppler_contact_us/application_controller'
module KepplerContactUs
  module Admin
    # MessagesController
    class MessagesController < ApplicationController
      layout 'keppler_contact_us/admin/layouts/application'
      before_action :authenticate_user!
      skip_before_action :verify_authenticity_token
      include KepplerContactUs::Concerns::ObjectQuery
      include KepplerContactUs::Concerns::Commons
      include KepplerContactUs::Concerns::History
      include KepplerContactUs::Concerns::DestroyMultiple

      before_action :folders
      before_action :labels

      # GET /messages
      def index 
        respond_to_formats(model.all)
        redirect_to_index if nothing_in_first_page?(@objects)
      end
      
      def new
        @object = model.new
      end
      
      def create
        message_params[:to_emails].split(', ')
        @object = model.new(message_params)
        if @object.save
          KepplerContactUs::Admin::MessageMailer.with(object: @object).send_mail(@object).deliver_now
          flash[:notice] = actions_messages(@objects)
        end
        redirect_to_index
      end

      # GET /messages/1
      def show
        @object.update(read: true)
      end

      # DELETE /messages/1
      def destroy
        @object.destroy
        redirect_to_index
      end

      def destroy_multiple
        model.destroy redefine_ids(params[:multiple_ids])
        redirect_to_index
      end

      def favorite
        @object.update(favorite: (@object.favorite ? false : true))
      end

      def sort
        model.sorter(params[:row])
        redirect_to_index
      end
      
      def send_message
        message_params[:to_emails].split(', ')
        @object = model.new(message_params)
        if @object.save
          KepplerContactUs::Admin::MessageMailer.with(object: @object).send_mail(@object).deliver_now
          flash[:notice] = actions_messages(@objects)
        end
        redirect_to_index
      end

      def sent
        objects_where(from_email: current_user.email)
      end
      
      def read
        objects_where(read: true)
      end
      
      def unread
        objects_where(read: !true)
      end

      def favorites
        objects_where(favorite: true)
      end

      def settings
        @setting = ::Setting.first
        @render = 'email_setting'
        # @social_medias = social_account_permit_attributes
        # @colors = social_account_colors
      end

      # def reply
      # end 
      
      # def share
      # end

      private

      def objects_where(condition)
        query = @q.result(distinct: true)
        filtered_objects = query.where(condition).order(position: :desc)
        if action_name.eql?('read')
          no_current_user_messages = model.reject_current_user_email
          no_current_user_ids = no_current_user_messages.map(&:id)
          filtered_objects = filtered_objects.where(id: no_current_user_ids)
        end
        @objects = filtered_objects.page(@current_page)
        @total = filtered_objects.size
        respond_to_formats(@objects)
      end

      def folders
        @folders = YAML.load_file(
          "rockets/keppler_contact_us/config/folders.yml"
        ).values.each(&:symbolize_keys!)
      end
      
      def labels
        @labels = YAML.load_file(
          "rockets/keppler_contact_us/config/labels.yml"
        ).values.each(&:symbolize_keys!)
      end

      # Only allow a trusted parameter 'white list' through.
      def message_params
        params.require(:message).permit(
          :name,
          :from_email,
          # { to_emails: [] },
          :to_emails,
          :subject,
          :content,
          :favorite,
          :read,
          :position,
          :deleted_at
        )
      end
    end
  end
end
