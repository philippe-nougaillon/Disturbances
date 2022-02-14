namespace :scraper do
  desc "TODO"
  task go: :environment do
    origine = 'Molsheim'
    url = "https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/molsheim-87214577"

    unparsed_html = HTTParty.get(url)
    page = Nokogiri::HTML(unparsed_html)
    disturbances = page.css('p.disturbanceName')
    puts '- ' * 50
    
    disturbances.each_with_index do | disturbance, index |
      content = disturbance.parent.parent.parent.parent.text
      if content.include?('Train TER ')
        train = content.split('Train TER ').last[0..5]
        puts 'TER N° ' + train
        départ = content.split('Départ').last[0..4]
        puts 'Départ: ' + départ
        destination = content.split('Destination').last.split('Mode').first
        puts 'Destination: ' + destination
        voie = content.split('Voie ').last.split('-').first
        puts 'Voie: ' + voie
        raison = content.split('-').last
        puts 'Raison: ' + raison

        begin
          Disturbance.create!(date: Date.today, train: train, départ: départ, origine: origine, destination: destination, voie: voie, raison: raison)
          puts '|--> Enregistré dans la BDD !'
        rescue
          puts '|--> Doublon! Pas enregistré.'  
        end  

        #puts content
        puts '- ' * 50     
      end
      #puts content
    end
  end

end
