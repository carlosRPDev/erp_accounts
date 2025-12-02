# frozen_string_literal: true

module ErpAccounts
  class CashierToday::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def visible_for_roles?(*roles)
      roles.any? { |r| @current_user.has_role?(r.to_s, account: @account) }
    end

    def totals
      { total_in_box: 150_000, sales_count: 28, diffs: 0 }
    end
  end
end
