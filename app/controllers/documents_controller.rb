class DocumentsController < ApplicationController

  #->Prelang (scaffolding:rails/scope_to_user)
  before_filter :require_user_signed_in, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_author, only: [:new, :create, :edit, :update, :destroy]

  def index
    @documents = Document.all.includes(:author)
  end

  def show
    @document = Document.find(params[:id])
    @author = @document.author
    unless @author == current_user
      @client_token = Braintree::ClientToken.generate
      @transaction = Transaction.new
    end
  end

  def new
    @document = Document.new
  end

  def edit
  end

  def create
    @document = Document.new(document_params)
    @document.author = current_user
    respond_to do |format|
      if @document.save
        format.html { redirect_to documents_path, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:title, :doc, :cover, :description, :price)
    end

    def redirect_if_not_author
      unless current_user.author?
        flash[:error] = "You need to register as an author to upload a document. Please register with us."
        redirect_to "/"
      end
    end

end