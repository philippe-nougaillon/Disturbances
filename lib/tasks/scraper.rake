namespace :scraper do

  desc "Scraper les informations du panneau des arrivéées de 22 gares"
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
        else
          if content.include?('réelle')
            arrivée = content.split('Arrivée réelle').last[0..4]
          else
            arrivée = content.split('Arrivée').last[0..4]
          end
        end  

        if sens == 'Départ'
          destination = content.split('Destination').last.split('Mode').first
        else
          provenance = content.split('Provenance').last.split('Mode').first
        end

        voie = content.split('Voie').last.split('-').first
        voie = voie.split('Retard').first if voie.include?('Retard')

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

        if false
          puts '- ' * 70
          puts gare + ' ' + sens
          puts '- ' * 70
          puts "Disturbance = " + disturbance.inspect
          puts "TER N° #{ train }"
          puts "Départ: #{ départ }" 
          puts "Arrivée: #{ arrivée }" 
          puts "Destination: #{ destination }" 
          puts "Raison: #{ raison }" 
          puts "Voie: #{ voie }" 
          puts "Provenance: #{ provenance } " 
          puts "Content = #{ content.inspect }" 
        end

        begin
          Disturbance.create!(date: Date.today, 
                              sens: sens, 
                              train: train, 
                              départ: départ, 
                              arrivée: arrivée, 
                              origine: gare, 
                              provenance: provenance, 
                              destination: destination, 
                              voie: voie, 
                              raison: raison)
          # puts '|--> Enregistrée dans la BDD !'
        rescue
          # puts '|--> Doublon! Pas enregistré.'  
        end  
      end
    end
  end

end
