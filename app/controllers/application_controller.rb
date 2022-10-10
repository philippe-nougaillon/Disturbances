class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :set_layout_variables

  private

    def set_layout_variables
      @sitename = "Disturbances v2.2"
      @sitename_short = "Disturbances"
      @themes = ["light", "dark", "cupcake", "bumblebee", "emerald", "corporate", "synthwave", "retro", "cyberpunk", "valentine", "halloween", "garden", "forest", "aqua", "lofi", "pastel", "fantasy", "wireframe", "black", "luxury", "dracula", "cmyk", "autumn", "business", "acid", "lemonade", "night", "coffee", "winter"]
    end


    def user_not_authorized
      flash[:alert] = "Vous n'êtes pas autorisé à effectuer cette action."
      redirect_to(request.referrer || (user_signed_in? ? disturbances_path : root_path))
    end
end
