class DisturbancesToXls < ApplicationService
    require 'spreadsheet'    
    attr_reader :disturbances

    def initialize(disturbances)
      @perturbations = disturbances
    end

    def call
      Spreadsheet.client_encoding = 'UTF-8'
    
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet name: 'Perturbations'
      bold = Spreadsheet::Format.new :weight => :bold, :size => 11

      headers = ["id", "date", "origine", "sens", "train", 
                  "départ prévu",
                  "départ réel",
                  "destination",
                  "arrivée prévue", 
                  "arrivée réelle", 
                  "provenance", 
                  "voie", 
                  "perturbation", 
                  "information", 
                  "gare_id",
                  "created_at", "updated_at"]

      sheet.row(0).concat headers
      sheet.row(0).default_format = bold
  
      index = 1
      @perturbations.each do | perturbation |
          fields_to_export = [
              perturbation.id, 
              perturbation.date,
              perturbation.origine,
              perturbation.sens,
              perturbation.train,
              perturbation.départ_prévu,
              perturbation.départ_réel,
              perturbation.destination,
              perturbation.arrivée_prévue,
              perturbation.arrivée_réelle,
              perturbation.provenance, 
              perturbation.voie,
              perturbation.perturbation,
              perturbation.information,
              perturbation.gare_id,
              perturbation.created_at, 
              perturbation.updated_at
          ]
          sheet.row(index).replace fields_to_export
          index += 1
      end
  
      return book

    end

end