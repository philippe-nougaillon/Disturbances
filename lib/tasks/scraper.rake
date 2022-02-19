namespace :scraper do
  desc "TODO"
  task go: :environment do
    scraping('Départ', 'Gare Strasbourg', 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/strasbourg-87212027' )
    scraping('Arrivée', 'Gare Strasbourg', 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/strasbourg-87212027')
  end

  def scraping(sens, gare, url)
    unparsed_html = HTTParty.get(url)
    page ||= Nokogiri::HTML(unparsed_html.body)
    disturbances = page.css('div.disturbanceNameRoot')
    puts '- ' * 70
    
    disturbances.each_with_index do | disturbance, index |
      #puts "disturbance = " + disturbance.inspect
      content = disturbance.parent.parent.parent.text
      if content.include?('Train TER ')
        # supprimer le css superflu
        content = content.split('}').last if content.include?('}')

        train = content.split('Train TER ').last[0..5]
        puts 'TER N° ' + train

        départ = ''
        arrivée= ''
        if sens == 'Départ'
          if content.include?('prévu')
            départ = content.split('Départ prévu').last[0..4]
          elsif content.include?('réel')
            départ = content.split('Départ réel').last[0..4]
          else
            départ = content.split('Départ').last[0..4]
          end
          puts 'Départ: ' + départ
        else
          if content.include?('réelle')
            arrivée = content.split('Arrivée réelle').last[0..4]
          else
            arrivée = content.split('Arrivée').last[0..4]
          end
          puts 'Arrivée: ' + arrivée
        end  

        if sens == 'Départ'
          destination = content.split('Destination').last.split('Mode').first
          puts 'Destination: ' + destination
        else
          provenance = content.split('Provenance').last.split('Mode').first
          puts 'Provenance: ' + provenance
        end

        voie = content.split('Voie').last.split('-').first
        voie = voie.split('Retard').first if voie.include?('Retard')
        puts 'Voie: ' + voie

        raison = content.split('-').last
        if raison.include?('Information')
          raison = raison.gsub('Information','')
        end
        if raison.include?('Voie')
          raison = raison.split('Voie').last
        end
        # supprimer le N° de Voie dans la raison
        if raison[0..1].include?(voie)
          if voie.to_i < 10
            raison = raison[1..-1]
          else
            raison = raison[2..-1]
          end
        end
        puts 'Raison: ' + raison

        begin
          Disturbance
              .create!( date: Date.today, 
                        sens: sens, 
                        train: train, 
                        départ: départ, 
                        arrivée: arrivée, 
                        origine: gare, 
                        provenance: provenance, 
                        destination: destination, 
                        voie: voie, 
                        raison: raison)
          puts '|--> Enregistrée dans la BDD !'
        rescue
          puts '|--> Doublon! Pas enregistré.'  
        end  

        puts "content = " + content.inspect
        puts '- ' * 70     
      end
    end
  end

end
