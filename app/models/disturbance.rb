class Disturbance < ApplicationRecord
    paginates_per 10
    default_scope { order('created_at DESC') }

    
    def self.to_xls(perturbations)
        require 'spreadsheet'    
    
        Spreadsheet.client_encoding = 'UTF-8'
    
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet name: 'Perturbations'
        bold = Spreadsheet::Format.new :weight => :bold, :size => 11

        headers = ["id", "date", "origine", "sens", "train", "départ", "destination",
                    "arrivée", "provenance", "voie", "raison", "information",
                    "created_at", "updated_at"]

        sheet.row(0).concat headers
        sheet.row(0).default_format = bold
    
        index = 1
        perturbations.each do | perturbation |
            fields_to_export = [
                perturbation.id, 
                perturbation.date,
                perturbation.origine,
                perturbation.sens,
                perturbation.train,
                perturbation.départ,
                perturbation.destination,
                perturbation.arrivée,
                perturbation.provenance, 
                perturbation.voie,
                perturbation.raison,
                perturbation.information,
                perturbation.created_at, 
                perturbation.updated_at
            ]
            sheet.row(index).replace fields_to_export
            index += 1
        end
    
        return book
    end
    
end
