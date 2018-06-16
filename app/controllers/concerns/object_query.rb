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
      format.csv { send_data objects.to_csv }
      format.xls { send_data objects.to_xls }
      format.json { render json: objects }
    end
  end
end
