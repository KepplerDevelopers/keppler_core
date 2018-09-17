# frozen_string_literal: true

module KepplerContactUs
  module Concerns
    # ObjectQuery
    module ObjectQuery
      extend ActiveSupport::Concern

      private

      def redirect_to_index
        redirect_to(
          {
            action: :index,
            page: (@current_page.to_i if params[:page]),
            search: @query
          },
          notice: actions_messages(model.new)
        )
      end

      def nothing_in_first_page?(objects)
        !objects.first_page? && objects.size.zero?
      end

      def send_format_data(objects, extension)
        models = objects.model.to_s.downcase.pluralize
        t_models = t("keppler.models.pluralize.#{models}").humanize
        filename = "#{t_models} - #{I18n.l(Time.now, format: :short)}"
        obj_ar = objects.order(:created_at).to_a
        case extension
        when 'csv' then send_data obj_ar.to_csv, filename: "#{filename}.csv"
        when 'xls' then send_data obj_ar.to_xls, filename: "#{filename}.xls"
        end
      end

      def respond_to_formats(objects)
        respond_to do |format|
          format.html
          format.csv { send_data objects.model.all.to_csv }
          format.xls { send_data objects.model.all.to_xls }
          format.json { render json: json_objects(objects) }
        end
      end

      protected

      def json_objects(objects)
        if action_name.eql?('index')
          if request.url.include?('page')
            objects.page(@current_page).order(position: :desc)
          else
            objects.model.all
          end
        else 
          objects
        end
      end
    end
  end
end
