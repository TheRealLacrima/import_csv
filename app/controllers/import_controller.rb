class ImportController < ApplicationController
  def index 
    @tables = ActiveRecord::Base.connection.tables.map do |tbl| 
                [tbl.titleize.singularize, tbl] unless ApplicationRecord::RESERVE_TABLES.include? tbl 
              end.compact
  end

  def import_model
    redirect_to send("#{params[:table]}_path")
  end
end
