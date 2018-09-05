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
    url = url.split('//').last.split('www.').last
    find_by_url(url)
  end

  def self.title(post_param, product_param, setting)
    post = post_param&.title
    product = product_param&.title || product_param&.name
    post || product || setting.name
  end

  def self.description(post_param, product_param, setting)
    unless post_param&.body.blank?
      body = post_param.body
      post = sanitize(body, tags: []).truncate(300)
    end
    product = product_param&.description || product_param&.body
    post || product || setting.description
  end

  def self.image(request, post_param, product_param, setting_param)
    post = post_param&.image
    product = product_param&.image || product_param&.photo
    setting = setting_param&.logo unless setting_param&.logo.blank?
    image = '/assets/admin/slice.png'
    url = request.protocol + request.host_with_port
    url + (post || product || setting || image).to_s
  end

  def self.search_field
    :title_or_description_or_url_cont_any
  end

  private

  def split_url
    self.url = url.split('//').last.split('www.').last
  end
end
