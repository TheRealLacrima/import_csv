require 'csv'
require "active_support/concern"

module Import
  extend ActiveSupport::Concern

  module ClassMethods
    def import(file, headers)
      # Process Column from Parameters
      headers.permit!
      columns = headers.to_hash.map { |k, v| v.blank? ? k : v } # Set the renamed columns, set to original name if blank
      na_columns = headers.to_hash.map { |k, v| k if k != v }.compact # Unassigned columns

      counter = 0
      # CSV reference: https://ruby-doc.org/stdlib-2.6.1/libdoc/csv/rdoc/CSV.html
      CSV.foreach(file.path, headers: columns, header_converters: :symbol) do |row|
        row.to_hash.reject! { |r| na_columns.include? r }

        if counter.zero? # Skip Create for Headers
          counter += 1
        else
          create! row
        end
      end
    end
  end
end