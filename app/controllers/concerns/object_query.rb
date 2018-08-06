# frozen_string_literal: true

# ObjectQuery
module ObjectQuery
  extend ActiveSupport::Concern

  private

  def redirect_to_index(_objects_path)
    redirect_to objects_path(page: @current_page.to_i.pred, search: @query)
  end

  def nothing_in_first_page?(objects)
    !objects.first_page? && objects.size.zero?
  end

  def send_format_data(objects, extension)
    models = objects.model.to_s.downcase.pluralize
    t_models = t("keppler.models.pluralize.#{models}").humanize
    filename = "#{t_models} - #{I18n.l(Time.now, format: :short)}"
    objects_array = objects.order(:created_at)
    case extension
    when 'csv'
      send_data objects_array.to_csv, filename: "#{filename}.csv"
    when 'xls'
      send_data objects_array.to_a.to_xls, filename: "#{filename}.xls"
    end
  end

  def respond_to_formats(objects)
    respond_to do |format|
      format.html
      format.csv { send_format_data(objects, 'csv') }
      format.xls { send_format_data(objects, 'xls') }
      format.json { render json: objects }
    end
  end
end
