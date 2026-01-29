class DisturbancesClean < ApplicationService

  def initialize()
  end

  def call
    #TODO : prendre que les disturbances créées / modifiées depuis la dernière fois
    message = ""
    Disturbance.unscope(:order).group(:date, :train, :perturbation).having('COUNT(*) >= 2').pluck(:date, :train, :perturbation).each do |date, train, perturbation|
      disturbances = Disturbance
      .where(date: date, train: train, perturbation: perturbation)
      .order(:created_at)

      survivors = []

      # 1. Déduplication par information non nulle
      disturbances
        .where.not(information: nil)
        .group_by(&:information)
        .each_value do |group|
          survivors << group.first
        end

      # 2. Gestion des informations nulles
      null_infos = disturbances.where(information: nil).to_a

      if survivors.empty?
        # Obligation de garder au moins une disturbance
        survivors << (null_infos.shift || disturbances.first)
      end

      # 3. Suppression des autres
      disturbances.each do |d|
        d.destroy unless survivors.include?(d)
      end
    end

  end
end