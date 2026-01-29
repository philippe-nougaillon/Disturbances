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
        if départ
          horaire = DateTime.new(Date.today.year, Date.today.month, Date.today.day, départ.split('h').first.to_i, départ.split('h').last.to_i, 0, "+01:00")
        else
          horaire = DateTime.new(Date.today.year, Date.today.month, Date.today.day, arrivée.split('h').first.to_i, arrivée.split('h').last.to_i, 0, "+01:00")
        end
        
        horaire = horaire.strftime("%Y-%m-%dT%I:%M")
        url = "https://www.ter.sncf.com/api/circulation-details?number=#{ train.to_i }&circulationDate=#{ horaire }&departureStopPlaceId=#{ gare_id }"
        réponse_informations = request_to :parse_repo_page, url: url
        
        if réponse_informations
          events = réponse_informations[0]['events'] if réponse_informations[0]
          information = events[0]['description'] if events
        end

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

        result_list_today.children.each_with_index do | item, index |
            service = item.child.children.first.children.first
            unless service.nil?
                mode = service.children[2].text
                if mode.include?('TER ')
                    numéro_service = mode.split('TER').last.strip
                    modalité = mode.split('TER').first.gsub('Mode', '').strip
                    horaire = service.children[0].text.split('Départ').last.first(5)
                    destination = service.children[1].child.text.split('Destination').last
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
    end

    source.update_columns(collected_at: DateTime.now)
  end

  def parse_repo_page(response, url:, data: {})
    return JSON.parse(response)
  end
end

