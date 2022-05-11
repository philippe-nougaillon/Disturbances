class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:status]

  def status
    @gares = Source.pluck(:gare).uniq
    @sources = Source.all
  end
end
