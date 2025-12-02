# frozen_string_literal: true

module ErpAccounts
  class InventorySummary::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def low_stock
      [
        { sku: 'P-001', name: 'Producto A', stock: 2 },
        { sku: 'P-023', name: 'Producto B', stock: 5 }
      ]
    end
  end
end
