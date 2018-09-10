# frozen_string_literal: true

# Seo Model
class Seo < ApplicationRecord
  include ActivityHistory
  include CloneRecord
  include Uploadable
  include Downloadable
  include Sortable
  acts_as_list
  acts_as_paranoid

  # Fields for the search form in the navbar
  def self.search_field
    fields = %i[position deleted_at]
    build_query(fields, :or, :cont)
  end

  # Funcion para armar el query de ransack
  def self.build_query(fields, operator, conf)
    query = fields.join("_#{operator}_")
    query << "_#{conf}"
    query.to_sym
  end

  def self.sitemap_code
    file = "#{Rails.root}/config/sitemap.rb"
    index_html = File.readlines(file)
    index_html.join('')
  end

  def self.robots_code
    file = "#{Rails.root}/public/robots.txt"
    index_html = File.readlines(file)
    index_html.join('')
  end

  def self.save_sitemap(code)
    file = "#{Rails.root}/config/sitemap.rb"
    File.write(file, code)

    system "ruby #{Rails.root}/config/sitemap.rb"
  end

  def self.save_robots(code)
    file = "#{Rails.root}/public/robots.txt"
    File.write(file, code)
  end
end
