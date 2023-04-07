class ServicesToXls < ApplicationService
    require 'spreadsheet'
    attr_reader :services
    private :services

    def initialize(services)
      @services = services
    end

    def call
      Spreadsheet.client_encoding = 'UTF-8'
    
      book = Spreadsheet::Workbook.new
      sheet = book.create_worksheet name: 'Services'
      bold = Spreadsheet::Format.new :weight => :bold, :size => 11

      headers = ["id",
                  "date",
                  "horaire",
                  "mode",
                  "numéro_service",
                  "origine",
                  "destination",
                  "created_at"]

      sheet.row(0).concat headers
      sheet.row(0).default_format = bold
  
      index = 1
      @services.each do | service |
          fields_to_export = [
            service.id, 
            service.date,
            service.horaire,
            service.mode,
            service.numéro_service,
            service.origine,
            service.destination,
            service.created_at
          ]
          sheet.row(index).replace fields_to_export
          index += 1
      end
  
      return book

    end

end