namespace :scraper do

  desc "Scraper les informations de perturbations"
  task go: :environment do

    DisturbancesGet.new.call

    puts "refreshing views"
    Gare.refresh
    Train.refresh
    Info.refresh
    Cancelled.refresh

  end

end
