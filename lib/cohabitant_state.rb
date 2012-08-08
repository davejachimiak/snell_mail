class CohabitantState
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
      { css: 'success', adj: 'reactivated' }
    end

    def inactive_info
      { css: 'info', adj: 'deactivated' }
    end
end
