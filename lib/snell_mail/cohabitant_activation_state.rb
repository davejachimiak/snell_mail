module SnellMail
  class CohabitantActivationState
    def initialize(cohabitant)
      @cohabitant = cohabitant
    end

    def message
      flash = @cohabitant.activated? ? 'success' : 'info'
      { flash: flash }
    end
  end
end
