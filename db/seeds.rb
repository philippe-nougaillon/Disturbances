# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

#Source.create(sens:, gare: , url: )

Source.create(sens: 'Arrivée', gare: 'Strasbourg',  url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/strasbourg-87212027')
Source.create(sens: 'Arrivée', gare: 'Haguenau',    url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/haguenau-87213058')
Source.create(sens: 'Départ',  gare: 'Molsheim',    url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/molsheim-87214577')
Source.create(sens: 'Départ',  gare: 'Sélestat',    url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/selestat-87214056')
Source.create(sens: 'Arrivée', gare: 'Colmar',      url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/colmar-87182014')
Source.create(sens: 'Départ',  gare: 'Mulhouse',    url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/mulhouse-87182063')
Source.create(sens: 'Arrivée', gare: 'Mulhouse Gare-centrale',  url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/mulhouse-gare-centrale-87533620')
Source.create(sens: 'Départ',  gare: 'Culmont Chalindrey',      url:'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/culmont-chalindrey-87142125')
Source.create(sens: 'Arrivée', gare: 'Troyes',      url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/troyes-87118000')
Source.create(sens: 'Arrivée', gare: 'Reims',       url:'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/reims-87171009')
Source.create(sens: 'Départ',  gare: 'Châlons en Champagne', url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/chalons-en-champagne-87174003')
Source.create(sens: 'Départ',  gare: 'Saint Dizier', url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/saint-dizier-87175000')
Source.create(sens: 'Départ',  gare: 'Bar le Duc',   url: 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/bar-le-duc-87175042')
    # scraping('Départ',  'Epinal',                 'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/epinal-87144006')
    # scraping('Départ',  'Nancy',                  'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/nancy-87141002')
    # scraping('Départ',  'Metz',                   'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/metz-87192039')
    # scraping('Arrivée', 'Longwy',                 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/longwy-87194001')
    # scraping('Arrivée', 'Conflans Jarny',         'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/conflans-jarny-87192666')
    # scraping('Départ',  'Thionville',             'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/thionville-87191007')
    # scraping('Départ',  'Forbach',                'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/forbach-87193003')
    # scraping('Départ',  'Sarreguemines',          'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/sarreguemines-87193615')
    # scraping('Arrivée', 'Verdun',                 'https://m.ter.sncf.com/grand-est/se-deplacer/prochaines-arrivees/verdun-87175778')
    # scraping('Départ',  'Munster',                'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/munster-87182394')
    # scraping('Départ',  'Saint-Dié-des-Vosges',   'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/saint-die-des-vosges-87144014')
    # scraping('Départ',  'Herrlisheim',            'https://m.ter.sncf.com/grand-est/se-deplacer/prochains-departs/herrlisheim-87212340')
