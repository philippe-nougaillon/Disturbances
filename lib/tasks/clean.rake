namespace :clean do

  desc "Supprime les perturbations doublons"
  task duplicate_disturbances_cleanning: :environment do

    DisturbancesClean.new.call

    puts "refreshing views"
    Gare.refresh
    Train.refresh
    Info.refresh
    Cancelled.refresh

  end

end
