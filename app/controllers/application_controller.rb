class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!

  private

    def user_not_authorized
      flash[:alert] = "Vous n'êtes pas autorisé à effectuer cette action."
      redirect_to(request.referrer || (user_signed_in? ? disturbances_path : root_path))
    end
end
