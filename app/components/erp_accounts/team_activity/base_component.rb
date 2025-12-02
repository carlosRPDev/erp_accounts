# frozen_string_literal: true

module ErpAccounts
  class TeamActivity::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def activities
      [
        { who: 'Oscar', action: 'creó comanda #12', time: '5m' },
        { who: 'Fernado', action: 'Finalizo pedido', time: '12m' }
      ]
    end
  end
end
