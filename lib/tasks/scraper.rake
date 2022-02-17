namespace :scraper do
  desc "TODO"
  task go: :environment do
    origine = 'Gare Strasbourg'
    url = 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/strasbourg-87212027'

    unparsed_html = HTTParty.get(url)
    page ||= Nokogiri::HTML(unparsed_html.body)
    disturbances = page.css('div.disturbanceNameRoot')
    puts '- ' * 50
    
    disturbances.each_with_index do | disturbance, index |
      #puts "disturbance = " + disturbance.inspect
      content = disturbance.parent.parent.parent.text
      if content.include?('Train TER ')
        train = content.split('Train TER ').last[0..5]
        puts 'TER N° ' + train

        if content.include?('prévu')
          départ = content.split('Départ prévu').last[0..20]
        else
          départ = content.split('Départ').last[0..4]
        end
        puts 'Départ: ' + départ

        destination = content.split('Destination').last.split('Mode').first
        puts 'Destination: ' + destination

        voie = content.split('Voie ').last.split('-').first
        puts 'Voie: ' + voie

        raison = content.split('-').last
        raison = raison.gsub('Information','')
        puts 'Raison: ' + raison

        begin
          Disturbance.create!(date: Date.today, train: train, départ: départ, origine: origine, destination: destination, voie: voie, raison: raison)
          puts '|--> Enregistré dans la BDD !'
        rescue
          puts '|--> Doublon! Pas enregistré.'  
        end  

        puts "content = " + content.inspect
        puts '- ' * 50     
      end
      #puts content
    end
  end

end
