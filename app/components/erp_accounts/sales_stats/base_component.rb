# frozen_string_literal: true

module ErpAccounts
  class SalesStats::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def series
      [ 40, 65, 30, 80, 55, 95, 70 ]
    end
  end
end
