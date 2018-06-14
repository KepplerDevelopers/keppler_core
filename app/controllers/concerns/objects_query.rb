# frozen_string_literal: true

# ObjectQuery
module ObjectQuery
  extend ActiveSupport::Concern

  private

  def first_page?(objects)
    objects.first_page?
  end

  def object_size_zero?(obj)
    obj = obj.size
    obj.zero?
  end

  def object_page(current_page)
    objects = roles.page(current_page)
    objects.order(position: :desc)
  end
end
