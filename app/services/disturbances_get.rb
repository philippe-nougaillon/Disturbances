require 'open-uri'
require 'nokogiri'
require 'tanakai'

class DisturbancesGet < ApplicationService
  # attr_reader :source_id
  # private :source_id

  def initialize()
    # @source = Source.find(source_id)
  end

  def call
    # puts "scraping #{@source.gare} (#{@source.sens})..."

    DisturbancesDancer.crawl!

    # puts "scraping #{@source.gare} (#{@source.sens})... Done."

    # Marquer la source comme 'traitée'
    # @source.update_columns(collected_at: DateTime.now)
  end
end

class DisturbancesDancer < Tanakai::Base
  USER_AGENTS = ["Chrome", "Firefox", "Safari", "Opera"]

  # Libellé de mode d'une circulation TER / Fluo dans le texte d'un item de la liste des prochains
  # passages, par exemple « ModeTrain Fluo 835017Voie1Retard estimé de 5 min ».
  # La Région Grand Est remplace progressivement la marque TER par Fluo sur ter.sncf.com :
  # « Train TER 830012 » à l'origine, « Train TER Fluo 830012 » observé en avril 2026,
  # « Train Fluo 830012 » observé en octobre 2026. La casse est ignorée (« FLUO »).
  # Pour les perturbations : trains et tram-trains seulement (TGV, DB, MOBIGO et cars ignorés).
  TRAIN_TER_FLUO = /Mode\s*(?<mode>Train(?:\s+spécial)?|TramTrain)\s+(?:TER|Fluo)(?:\s+(?:TER|Fluo))?\s+(?<numéro>\d+|[A-Z]{1,2}\d+)/i

  # Pour les services (départs) : tous les modes TER / Fluo, cars compris. S'applique au seul texte
  # de la colonne Mode (« ModeCar Fluo 44125 », « ModeTramTrain TER 12345 », « ModeTrain spécial TER TS100 »).
  SERVICE_TER_FLUO = /\AMode\s*(?<mode>.+?)\s+(?:TER|Fluo)(?:\s+(?:TER|Fluo))?\s+(?<numéro>\S+)\z/i
  @name = "disturbances_dancer"
  @engine = :selenium_chrome
  @start_urls = Source.all.pluck(:url)
  @config = {
    user_agent: -> { USER_AGENTS.sample },
    retry_request_errors: [Net::ReadTimeout],
    window_size: [1366, 768],
    disable_images: true,
    before_request: { delay: 1..2 }
  }
  
  def parse(response, url:, data: {})
    source = Source.find_by(url: url)
    response.xpath("//div[@data-testid='disturbance-name']").each do |disturbance|

      content = disturbance.parent.parent.parent.text
      # supprimer le css superflu
      content = content.split('}').last if content.include?('}')

      # Ne garder que les trains TER / Fluo (voir TRAIN_TER_FLUO)
      train_match = TRAIN_TER_FLUO.match(content)

      if train_match
        train = train_match[:numéro]
        départ = nil
        départ_prévu = nil
        départ_réel = nil
        arrivée = nil
        arrivée_prévue = nil
        arrivée_réelle = nil
        réponse_informations = nil
        information = nil

        if source.sens == 'Départ'
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

        if source.sens == 'Départ'
          destination = content.split('Destination').last.split('Mode').first
        else
          provenance = content.split('Provenance').last.split('Mode').first
        end

        # Supprimer les informations parasites
        voie = content.split('Voie').last.split('-').first
        voie = voie.split('Retard').first if voie.include?('Retard')
        voie = voie.split('Modifié').first if voie.include?('Modifié')
        voie = voie.split('Arrêts supplémentaires').first if voie.include?('Arrêts supplémentaires')
        voie = voie.split('Information').first if voie.include?('Information')
        
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

        # si voie = raison
        if voie == raison
          voie = voie.to_i.to_s
          raison = raison.split(voie).last
        end

        # ne pas garder que les retards de moins de 10 min
        #next if raison == 'Retard estimé de 5 min'

        # supprimer les parasites parfois collés à 'Supprimé'
        raison = 'Supprimé' if raison.include?('Supprimé') && raison[0] != 'S'

        # supprimer le premier charactère s'il est pas voulu
        raison.slice!(0) if raison[1] == raison[1].upcase

        # remplacer 'non disponible' par 'ND'
        voie = voie.gsub('non disponible', 'ND') if voie.include?('non disponible')
        
        # Rechercher les compléments d'informations
        gare_id = source.url.split('-').last
        # L'heure affichée s'écrit « 10:15 » (anciennement « 10h15 »). L'API renvoie la circulation la plus
        # proche de circulationDate : une heure fausse peut rattacher la perturbation au train du lendemain.
        heure, minute = (départ || arrivée).to_s.split(/[h:]/).map(&:to_i)
        horaire = DateTime.new(Date.today.year, Date.today.month, Date.today.day, heure || 0, minute || 0, 0, "+01:00")
        
        horaire = horaire.strftime("%Y-%m-%dT%H:%M")
        url = "https://www.ter.sncf.com/api/circulation-details?number=#{ train.to_i }&circulationDate=#{ horaire }&departureStopPlaceId=#{ gare_id }"
        réponse_informations = request_to :parse_repo_page, url: url
        
        information = information_depuis(réponse_informations)

        # if false
          # puts '- ' * 70
          # puts "#{ source.gare } (#{ gare_id }) #{ source.sens }"
          # puts '- ' * 70
          # #puts "Disturbance = " + disturbance.inspect
          # puts "TER N° #{ train }"
          # puts "Départ prévu: #{ départ_prévu }" 
          # puts "Départ réel: #{ départ_réel }" 
          # puts "Départ: #{ départ }" 
          # puts "Arrivée prévue: #{ arrivée_prévue }" 
          # puts "Arrivée réelle: #{ arrivée_réelle }" 
          # puts "Arrivée: #{ arrivée }" 
          # puts "Destination: #{ destination }" 
          # puts "Raison: #{ raison }" 
          # puts "Voie: #{ voie }" 
          # puts "Provenance: #{ provenance } " 
          # puts "Content = #{ content.inspect }" 
          # puts "Information: #{ information }"
          # puts réponse_informations
          # puts Time.find_zone('Paris').now.hour
        # end

        current_hour = Time.find_zone('Paris').now.hour

        if ( raison == 'Supprimé' && current_hour > 5 && ((départ && départ.first(2).to_i < current_hour) || (départ_prévu && départ_prévu.first(2).to_i < current_hour) || (arrivée && arrivée.first(2).to_i < current_hour) || (arrivée_prévue && arrivée_prévue.first(2).to_i < current_hour)) )
          puts '|--> Suppression du lendemain! Pas enregistré.'  
        else
          begin
            Disturbance.create!(date: Date.today, 
                            sens: source.sens, 
                            train: train,
                            gare_id: gare_id, 
                            départ: départ, 
                            départ_prévu: départ_prévu,
                            départ_réel: départ_réel,
                            arrivée: arrivée, 
                            arrivée_prévue: arrivée_prévue,
                            arrivée_réelle: arrivée_réelle,
                            origine: source.gare, 
                            provenance: provenance&.gsub(/effacé/i, ''), 
                            destination: destination&.gsub(/effacé/i, ''), 
                            voie: voie, 
                            perturbation: Disturbance.remove_plural(raison), 
                            information: information,
                            information_payload: réponse_informations,
                            source_id: source.id)
            puts '|--> Enregistrée dans la BDD !'
          rescue
            puts '|--> Doublon! Pas enregistré.'  
          end
        end
      end
    end

    #
    # Scraping Services
    #

    if source.sens == "Départ"
        result_lists = response.css('ul[data-testid="result-list"]')

        # Ne prendre que la liste d'aujourd'hui, pas du lendemain
        result_list_today = result_lists.first

        if result_list_today
          result_list_today.css('li').each do |item|
              # Les colonnes sont repérées par leur libellé (<span>Mode</span>, <span>Destination</span>) et non
              # par leur position : un train retardé affiche une colonne « Départ réel » supplémentaire.
              mode = item.at_xpath(".//p[span[normalize-space(text())='Mode']]")&.text.to_s.strip
              service_match = SERVICE_TER_FLUO.match(mode)
              next unless service_match

              numéro_service = service_match[:numéro]
              modalité = service_match[:mode]
              horaire = item.text[/Départ(?:\s*prévu)?\s*(\d{1,2}:\d{2})/, 1]
              destination = item.at_xpath(".//p[span[normalize-space(text())='Destination']]")&.text&.sub(/\ADestination\s*/, '')

              # Item incomplet (libellé vide) : on saute pour éviter un crash
              next if horaire.nil? || destination.nil?

              puts "-*-" *10
              puts "HORAIRE : " + horaire
              puts "DESTINATION : " + destination
              puts "NUMÉRO DU SERVICE : " + numéro_service
              puts "MODALITÉ : " + modalité

              begin
                  Service.create!(date: Date.today, numéro_service: numéro_service, horaire: horaire, origine: source.gare, destination: destination, mode: modalité)
                  puts "SAUVEGARDÉ !"
              rescue
                  puts "DOUBLON !"
              end
              puts "-*-" *10
          end
        end
    end

    source.update_columns(collected_at: DateTime.now)
  end

  # Réponse de /api/circulation-details, lue par le navigateur : Chrome affiche un JSON brut dans un <pre>,
  # le texte de la page est donc le JSON. Quand Cloudflare interpose sa page de vérification
  # (« Just a moment... », challenge « managed » sur /api/, intermittent en production depuis juin 2026)
  # ou que la réponse n'est pas du JSON, on renvoie nil : la perturbation est enregistrée sans information
  # et la passe continue, au lieu de s'arrêter sur JSON::ParserError et de perdre les sources suivantes.
  def parse_repo_page(response, url:, data: {})
    texte = response.text.strip
    return JSON.parse(texte) if texte.start_with?('[', '{')

    titre = response.at_css('title')&.text.to_s.strip
    puts "|--> API circulation-details : réponse non JSON (#{titre.presence || texte.first(60).inspect}), information ignorée."
    nil
  rescue JSON::ParserError => e
    puts "|--> API circulation-details : JSON invalide (#{e.message.first(80)}), information ignorée."
    nil
  end

  private

  # Description du premier évènement de la charge utile de circulation-details
  # ([{ "events" => [{ "description" => "…" }] }]), nil si elle n'a pas cette forme.
  def information_depuis(payload)
    payload.dig(0, 'events', 0, 'description') if payload.is_a?(Array)
  rescue TypeError
    nil
  end
end

