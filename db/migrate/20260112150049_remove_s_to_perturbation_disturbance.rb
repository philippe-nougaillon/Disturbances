class RemoveSToPerturbationDisturbance < ActiveRecord::Migration[7.0]
  def change
    Disturbance.each do |disturbance|
      disturbance.update!(perturbation: Disturbance.remove_plural(disturbance.perturbation))
    end

    disturbances = Disturbance.where("destination ILIKE ?", "%effacé%")
      .or(Disturbance.where("provenance ILIKE ?", "%effacé%"))

    disturbances.each do |disturbance|
      if disturbance.destination
        disturbance.update!(destination: disturbance.destination.gsub(/effacé/i, ''))
      end

      if disturbance.provenance
        disturbance.update!(provenance: disturbance.provenance.gsub(/effacé/i, ''))
      end
    end

  end
end
