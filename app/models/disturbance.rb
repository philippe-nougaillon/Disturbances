# == Schema Information
#
# Table name: disturbances
#
#  id                  :bigint           not null, primary key
#  arrivée             :string
#  arrivée_prévue      :string
#  arrivée_réelle      :string
#  date                :string
#  destination         :string
#  départ              :string
#  départ_prévu        :string
#  départ_réel         :string
#  information         :string
#  information_payload :jsonb
#  origine             :string
#  perturbation        :string
#  provenance          :string
#  raison              :string
#  sens                :string
#  train               :string
#  voie                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  gare_id             :integer
#  source_id           :bigint           not null
#
# Indexes
#
#  index_disturbances_on_perturbation  (perturbation)
#  index_disturbances_on_source_id     (source_id)
#  super_index_uniq                    (date,sens,train,perturbation) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (source_id => sources.id)
#
class Disturbance < ApplicationRecord

    belongs_to :source

    default_scope { order('disturbances.created_at DESC') }

    paginates_per 25

    def self.perturbations
        ['Arrêt',
        'Modifié',
        'Retard',
        'Retard > 15 min',
        'Retard > 30 min',
        'Retard > 60 min',
        'Retard estimé de 5 min',
        'Retard estimé de 10 min',
        'Retard estimé de 15 min',
        'Retard estimé de 20 min',
        'Retard estimé de 25 min',
        'Retard estimé de 30 min',
        'Retard estimé de 35 min',
        'Retard estimé de 40 min',
        'Retard estimé de 45 min',
        'Retard estimé de 50 min',
        'Retard estimé de 55 min',
        'Retard estimé de 60 min',
        'Retard estimé de 70 min',
        'Retard estimé de 80 min',
        'Retard estimé de 90 min',
        'Retard estimé de 100 min',
        'Retard estimé de 110 min',
        'Retard estimé de 120 min',
        'Retard estimé de 130 min',
        'Retard estimé de 140 min',
        'Retard estimé de 150 min',
        'Retard estimé de 160 min',
        'Retard estimé de 170 min',
        'Retard estimé de 180 min',
        'Retard estimé de 200 min',
        'Retard estimé de 210 min',
        'Retard estimé de 250 min',
        'Retard estimé de 290 min',
        'Supprimé',
        'Autocars de remplacement']
    end

    # Enlève tous les s en trop pour unifier les messages
    def self.remove_plural(perturbation)
        # Hash du mot au pluriel avec sa version au singulier, le dernier est pour enlever le s à la fin du string, peu importe le texte
        plural_to_singular = {
            /Arrêts/ => 'Arrêt',
            /supplémentaires/ => 'supplémentaire',
            /s$/ => ''
        }

        perturbation_cleaned = perturbation

        plural_to_singular.each do |plural, singular|
            perturbation_cleaned = perturbation_cleaned.gsub(plural, singular)
        end

        perturbation_cleaned
    end

    def self.filter_by_trains(trains)
        ranges = trains.split(';').map do |range_str|
            start_str, end_str = range_str.split('-')
            start_str = start_str&.strip
            end_str = end_str&.strip
            end_str.blank? ? { single: start_str } : { range: [start_str, end_str] }
        end

        conditions = []
        values = []

        ranges.each do |entry|
            if entry[:single]
                conditions << "(disturbances.train = ?)"
                values << entry[:single]
            elsif entry[:range]
                conditions << "(disturbances.train BETWEEN ? AND ?)"
                values += entry[:range]
            end
        end

        unless conditions.empty?
            sql_condition = conditions.join(' OR ')
            return self.where(sql_condition, *values)
        end
    end
end
