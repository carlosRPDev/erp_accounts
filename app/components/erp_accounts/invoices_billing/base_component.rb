# frozen_string_literal: true

module ErpAccounts
  class InvoicesBilling::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def visible_for?(role)
      @current_user.has_role?(role.to_s, account: @account)
    end

    def stats
      { emitted: 24, pending: 5 }
    end
  end
end
