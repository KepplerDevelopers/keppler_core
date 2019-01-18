# frozen_string_literal: true

# ObjectQuery
module ObjectQuery
  extend ActiveSupport::Concern

  private

  def redirect_to_index(objects)
    return if listing? && (objects.first_page? || !objects.size.zero?)
    redirect_to(
      {
        action: :index,
        page: (@current_page.to_i if params[:page]),
        search: @query
      },
      notice: actions_messages(model.new)
    )
  end

  def send_format_data(objects, extension)
    models = objects.model.to_s.downcase.pluralize
    filename = "#{models}-#{Date.today}"
    case extension
    when 'csv'
      send_data objects.to_csv, filename: "#{filename}.csv"
    when 'xls'
      send_data objects.to_a.to_xls, filename: "#{filename}.xls"
    end
  end

  def respond_to_formats(objects)
    respond_to do |format|
      format.html
      format.csv { send_format_data(objects.model.all, 'csv') }
      format.xls { send_format_data(objects.model.all, 'xls') }
      format.json { render json: json_objects(objects) }
    end
  end

  protected

  def json_objects(objects)
    if request.url.include?('page')
      objects.page(@current_page).order(position: :desc)
    else
      objects.model.all
    end
  end
end
