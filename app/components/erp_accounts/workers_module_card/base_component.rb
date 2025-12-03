# frozen_string_literal: true

module ErpAccounts
  class WorkersModuleCard::BaseComponent < ViewComponent::Base
    def initialize(current_user:, account:)
      @current_user = current_user
      @account = account
    end

    def visible?
      @current_user.has_role?(:owner, account: @account)
    end

    def workers_path
      ErpWorkers::Engine.routes.url_helpers.accounts_workers_path(account_id: @account.id)
    end
  end
end
