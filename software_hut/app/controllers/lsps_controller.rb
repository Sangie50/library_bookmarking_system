# Controller for the LSP model
# Authors: Chelsea Huang, Sangramithra Bala Amuthan, William Lee

require "open-uri"
require "pdf-reader"

class LspsController < ApplicationController
  # DELETE /lsps/1
  def destroy
    @lsp.destroy
    redirect_to @lsp.student, notice: "LSP was successfully deleted."
  end

  # GET /lsps/upload
  def upload
    render layout: false
  end

  # extractor = Extractors::LspExtractor.new(file)
    # begin
    #   extracted_data = extractor.extract
    # rescue Extractors::LspExtractor::LspExtractionError => e
    #   redirect_to upload_lsps_path, alert: e.message
    # else


  #POST /lsps/confirm
  def confirm  
  #   session[:lsp_data].delete(:student)
  #   redirect_to new_student_path
  end

  # POST /lsps/extract
  def extract
    file = params[:extract_lsp][:file].tempfile
    extractor = Extractors::LspExtractor.new(file)
    begin
      extracted_data = extractor.extract
    rescue Extractors::LspExtractor::LspExtractionError => e
      redirect_to upload_lsps_path, alert: e.message
    else
      session[:lsp_data] = extracted_data
      @student = Student.find(extracted_data[:student][:registration_number])
      if @student
        session[:lsp_data] = extracted_data 
        session[:lsp_data].delete(:student)
        flash[:notice] = "LSP extracted successfully. Editing existing student's LSP"
        render :confirm
      else
        next_path = new_student_path
        flash[:notice] = "LSP extracted successfully. Creating new student with LSP"
        redirect_to next_path 
      end
    end
  end

  private
  def upload_params
    params.require(:upload).permit(:pdf)
  end
 

end
