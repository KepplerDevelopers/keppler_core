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
    if request.url.include?('page')
      objects.page(@current_page).order(position: :desc)
    else
      objects.model.all
    end
  end
end
