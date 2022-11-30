class BusinessesController < ApplicationController
  def index; end
  
  def import
    if params[:commit] == 'Import'
      Business.import(params[:file], params[:headers])
      
      redirect_to root_path, notice: "Imported successfully."

    elsif params[:commit] == 'Process'
      filepath = params[:file].path
      @headers =  CSV.open(filepath, &:readline) # Read the first row 'CSV Headers'
  
      respond_to do |format|
        format.turbo_stream
      end
    end
  end
end
