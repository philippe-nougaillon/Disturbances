class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:status]

  def status
    @disturbances = Disturbance.select(:origine,:perturbation, :information, :created_at).where("DATE(disturbances.created_at) = ?", Date.today).group(:origine, :perturbation, :information, :created_at)
  end
end
