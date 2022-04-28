# frozen_string_literal: true

module DisturbanceDecorator
    def perturbation_style
        self.perturbation.include?('Supprimé') ? 'color: red;' : (self.perturbation.include?('Retard') ? 'color: orange;'  : '')
    end
end
