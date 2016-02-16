# IndexHelper Backoffice
module IndexHelper
  def entries(total, objects)
    unless total.zero?
      content_tag :div, class: 'entries hidden-xs' do
        message(total, objects)
      end
    end
  end

  private

  def message(total, objects)
    if objects.first_page?
      t('keppler.messages.record_msg', from: 1, to: objects.size, total: total)
    elsif objects.last_page?
      t('keppler.messages.record_msg',
        from: from(objects), to: total, total: total)
    else
      t('keppler.messages.record_msg',
        from: from(objects), to: to(objects), total: total)
    end
  end

  # Calculate number that begins the page
  def from(objects)
    ((objects.current_page * objects.default_per_page) -
    objects.default_per_page) + 1
  end

  # Calculate the number that ends the page
  def to(objects)
    objects.current_page * objects.default_per_page
  end
end
