class UsersController < ApplicationController
  before_action :is_user_authorized

  private
    def is_user_authorized
      authorize User
    end
end