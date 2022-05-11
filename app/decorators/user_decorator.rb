# frozen_string_literal: true

module UserDecorator
    def nom_prénom
        "#{ self.nom } #{ self.prénom }"
    end
end
