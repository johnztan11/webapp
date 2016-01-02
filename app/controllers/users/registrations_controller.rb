class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  layout "landing"

  prepend_before_action :redirect_if_signed_in
  before_action :setup_documents_for_purchase

  def create
    @registering = true
    super
  end

  def new
    super
  end

  def edit
    super
  end

  # def after_sign_up_path_for(resource)
  #   @registering = true
  # end

  private

  def redirect_if_signed_in
    if user_signed_in?
      redirect_to documents_path
    elsif @registering
      new_user_registration_path
    end
  end

  def setup_documents_for_purchase
    @documents = Document.all
  end
end
