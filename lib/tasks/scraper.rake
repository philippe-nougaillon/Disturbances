namespace :scraper do

  desc "Scraper les informations de perturbations"
  task go: :environment do

    Source.all.each do | source |
      DisturbancesGet.new(source.id).call
    end

  end

end
