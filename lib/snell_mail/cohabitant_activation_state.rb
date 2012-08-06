module SnellMail
  class CohabitantActivationState
    attr_accessor :cohabitant

    def initialize(cohabitant)
      @cohabitant = cohabitant
    end

    def info
      if cohabitant.activated?
        active_info
      else
        inactive_info
      end
    end

    private

      def active_info
        { flash: 'success', adj: 'reactivated' }
      end

      def inactive_info
        { flash: 'info', adj: 'deactivated' }
      end
  end
end
