# frozen_string_literal: true

# MetaTag Model
class MetaTag < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  include Uploadable
  include Downloadable
  include Sortable
  acts_as_list
  before_save :split_url
  validates_uniqueness_of :url

  validates_presence_of :title, :meta_tags, :url

  def self.get_by_url(url)
    url = url.split('//').last.split('/').join('/').split('www.').last
    find_by_url(url)
  end

  def self.search_field
    :title_or_description_or_url_cont_any
  end

  private

  def split_url
    self.url = url.split('//').last.split('/').join('/').split('www.').last
  end
end
