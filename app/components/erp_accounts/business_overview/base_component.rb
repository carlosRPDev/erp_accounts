# frozen_string_literal: true

module ErpAccounts
  class BusinessOverview::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def owner?
      @current_user.has_role?("owner", account: @account)
    end

    def visible_for_roles?(*roles)
      roles.any? { |r| @current_user.has_role?(r.to_s, account: @account) } || owner?
    end
  end
end
