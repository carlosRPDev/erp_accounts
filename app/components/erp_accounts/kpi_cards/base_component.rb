# frozen_string_literal: true

module ErpAccounts
  class KpiCards::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def kpis
      {
      ventas_hoy: 240_000,
      pedidos_nuevos: 12,
      clientes_activos: 58,
      tickets_abiertos: 3
      }
    end
  end
end
