# app/controllers/documents_controller.rb
class DocumentsController < ApplicationController
  def index
    @documents = Document.all
    @document = Document.new
  end

  def create
    @document = Document.new(document_params)

    if @document.file.attached?
      @document.name = @document.file.filename.base # Set name from the file's original name
    end

    if @document.save
      ProcessDocumentJob.perform_async(@document.id)
      redirect_to @document, notice: "Document uploaded successfully."
    else
      render :index
    end
  end

  def show
    @document = Document.find(params[:id])
    @chunks = @document.document_chunks.pluck(:content)
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to documents_path, notice: "Document deleted successfully."
  end

  private

  def document_params
    params.require(:document).permit(:name, :file)
  end
end
