# frozen_string_literal: true

module SourceDecorator
    def sens_et_gare
        if self.sens == 'Départ'
            "-> #{ self.gare }"
        else
            "<- #{ self.gare }"
        end
    end    

    def gare_et_sens
        if self.sens == 'Départ'
            "#{ self.gare } ->"
        else
            "#{ self.gare } <-"
        end
    end      
end
