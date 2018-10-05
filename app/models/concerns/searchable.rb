# frozen_string_literal: true

# Keppler
module Searchable
  extend ActiveSupport::Concern
  included do
    # Fields for the search form in the navbar
    def self.search_field
      build_query(index_attributes, :or, :cont)
    end

    # Funcion para armar el query de ransack
    def self.build_query(fields, operator, conf)
      types = %i[string text]
      fields = columns.select do |c|
        fields.include?(c.name.to_sym) && types.include?(c.type)
      end
      (fields.map(&:name).join("_#{operator}_") << "_#{conf}").to_sym
    end

    # Return a list of attributes in symbol
    def self.listing_attributes
      c = column_names.select { |x| index_attributes.include?(x.to_sym) }
      c.map(&:to_sym)
    end
  end
end
