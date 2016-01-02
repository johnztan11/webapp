class Users::SessionsController < Devise::SessionsController
  include ApplicationHelper
  layout "landing"
  def create
    super
  end

  def new
    super
  end
end
