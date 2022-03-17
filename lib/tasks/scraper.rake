namespace :scraper do

  desc "Scraper les informations du panneau des arrivées de 22 gares"
  task go: :environment do
    scraping('Départ',  'Gare Strasbourg',  'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/strasbourg-87212027' )
    scraping('Arrivée', 'Gare Strasbourg',  'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/strasbourg-87212027')
    scraping('Arrivée', 'Haguenau',         'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/haguenau-87213058')
    scraping('Départ',  'Molsheim',         'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/molsheim-87214577')
    scraping('Départ',  'Sélestat',         'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/selestat-87214056')
    scraping('Arrivée', 'Colmar',           'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/colmar-87182014')
    scraping('Départ',  'Mulhouse',         'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/mulhouse-87182063')
    scraping('Arrivée', 'Mulhouse Gare-centrale','https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/mulhouse-gare-centrale-87533620')
    scraping('Départ',  'Culmont Chalindrey','https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/culmont-chalindrey-87142125')
    scraping('Arrivée', 'Troyes',           'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/troyes-87118000')
    scraping('Arrivée', 'Reims',            'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/reims-87171009')
    scraping('Départ',  'Châlons en Champagne','https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/chalons-en-champagne-87174003')
    scraping('Départ',  'Saint Dizier',     'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/saint-dizier-87175000')
    scraping('Départ',  'Bar le Duc',       'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/bar-le-duc-87175042')
    scraping('Départ',  'Epinal',           'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/epinal-87144006')
    scraping('Départ',  'Nancy',            'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/nancy-87141002')
    scraping('Départ',  'Metz',             'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/metz-87192039')
    scraping('Arrivée', 'Longwy',           'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/longwy-87194001')
    scraping('Arrivée', 'Conflans Jarny',   'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/conflans-jarny-87192666')
    scraping('Départ',  'Thionville',       'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/thionville-87191007')
    scraping('Départ',  'Forbach',          'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/forbach-87193003')
    scraping('Départ',  'Sarreguemines',    'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/sarreguemines-87193615')
    scraping('Arrivée', 'Verdun',           'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/verdun-87175778')
  end

  def scraping(sens, gare, url)
    unparsed_html = HTTParty.get(url)
    page ||= Nokogiri::HTML(unparsed_html.body)
    disturbances = page.css('div.disturbanceNameRoot')
  
    disturbances.each_with_index do | disturbance, index |
      content = disturbance.parent.parent.parent.text
      if content.include?('Train TER ')
        # supprimer le css superflu
        content = content.split('}').last if content.include?('}')

        train = content.split('Train TER ').last[0..5]

        départ = nil
        départ_prévu = nil
        départ_réel = nil
        arrivée = nil
        arrivée_prévue = nil
        arrivée_réelle = nil
        réponse_informations = nil
        information = nil

        if sens == 'Départ'
          if content.include?('Départ prévu')
            départ_prévu = content.split('Départ prévu').last[0..4]
          end
          if content.include?('Départ réel')
            départ_réel = content.split('Départ réel').last[0..4]
          end
          if !départ_prévu && !départ_réel && content.include?('Départ')
            départ_prévu = content.split('Départ').last[0..4]
          end

          if départ_prévu 
            départ = départ_prévu
          else
            départ = départ_réel
          end
        else
          if content.include?('Arrivée prévue')
            arrivée_prévue = content.split('Arrivée prévue').last[0..4]
          elsif content.include?('Arrivée réelle')
            arrivée_réelle = content.split('Arrivée réelle').last[0..4]
          else  
            arrivée_prévue = content.split('Arrivée').last[0..4]
          end  
          if arrivée_prévue
            arrivée = arrivée_prévue
          else
            arrivée = arrivée_réelle
          end
        end  

        if sens == 'Départ'
          destination = content.split('Destination').last.split('Mode').first
        else
          provenance = content.split('Provenance').last.split('Mode').first
        end

        voie = content.split('Voie').last.split('-').first
        voie = voie.split('Retard').first if voie.include?('Retard')
        voie = voie.split('Modifié').first if voie.include?('Modifié')

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

        # Rechercher les compléments d'information
        gare_id = url.split('-').last
        if départ
          horaire = DateTime.new(Date.today.year, Date.today.month, Date.today.day, départ.split('h').first.to_i, départ.split('h').last.to_i, 0, "+01:00")
        else
          horaire = DateTime.new(Date.today.year, Date.today.month, Date.today.day, arrivée.split('h').first.to_i, arrivée.split('h').last.to_i, 0, "+01:00")
        end  
        
        horaire = horaire.strftime("%Y-%m-%dT%I:%M")
        réponse_informations = getInformation(train.to_i, horaire, gare_id)
        if réponse_informations
          events = réponse_informations[0]['events']
          information = events[0]['description'] if events
        end

        if true
          puts '- ' * 70
          puts "#{ gare } (#{ gare_id }) #{ sens }"
          puts '- ' * 70
          #puts "Disturbance = " + disturbance.inspect
          puts "TER N° #{ train }"
          puts "Départ prévu: #{ départ_prévu }" 
          puts "Départ réel: #{ départ_réel }" 
          puts "Départ: #{ départ }" 
          puts "Arrivée prévue: #{ arrivée_prévue }" 
          puts "Arrivée réelle: #{ arrivée_réelle }" 
          puts "Arrivée: #{ arrivée }" 
          puts "Destination: #{ destination }" 
          puts "Raison: #{ raison }" 
          puts "Voie: #{ voie }" 
          puts "Provenance: #{ provenance } " 
          puts "Content = #{ content.inspect }" 
          puts "Information: #{ information }"
          puts réponse_informations
        end

        begin
          Disturbance.create!(date: Date.today, 
                              sens: sens, 
                              train: train,
                              gare_id: gare_id, 
                              départ: départ, 
                              départ_prévu: départ_prévu,
                              départ_réel: départ_réel,
                              arrivée: arrivée, 
                              arrivée_prévue: arrivée_prévue,
                              arrivée_réelle: arrivée_réelle,
                              origine: gare, 
                              provenance: provenance, 
                              destination: destination, 
                              voie: voie, 
                              raison: raison, 
                              information: information,
                              information_payload: réponse_informations)
          # puts '|--> Enregistrée dans la BDD !'
        rescue
          # puts '|--> Doublon! Pas enregistré.'  
        end  
      end
    end
  end

  def getInformation(train, horaire, gare_id)
    # https://m.ter.sncf.com/api/circulation-details?number=9568&circulationDate=2022-03-15T08:52:00&departureStopPlaceId=87212027
    url = "https://m.ter.sncf.com/api/circulation-details?number=#{ train }&circulationDate=#{ horaire }&departureStopPlaceId=#{ gare_id }"
    #puts url
    unparsed_json = HTTParty.get(url)
    JSON.parse(unparsed_json.body)
  end

end
