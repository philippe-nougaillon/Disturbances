class RemoveSToPerturbationDisturbance < ActiveRecord::Migration[7.0]
  def change

    Disturbance.find_each do |disturbance|
      disturbance.perturbation = Disturbance.remove_plural(disturbance.perturbation)
      if Disturbance.where(perturbation: disturbance.perturbation, date: disturbance.date, sens: disturbance.sens, train: disturbance.train).where.not(id: disturbance.id).count == 0
        disturbance.save
      else
        disturbance.destroy
      end
    end

    disturbances = Disturbance.where("destination ILIKE ?", "%effacé%")
      .or(Disturbance.where("provenance ILIKE ?", "%effacé%"))

    disturbances.find_each do |disturbance|
      if disturbance.destination
        disturbance.update!(destination: disturbance.destination.gsub(/effacé/i, ''))
      end

      if disturbance.provenance
        disturbance.update!(provenance: disturbance.provenance.gsub(/effacé/i, ''))
      end
    end

  end
end
