# frozen_string_literal: true

module ErpAccounts
  class AccountsController < ApplicationController
    layout "erp_accounts/application"

    before_action :authenticate_user!
    before_action :load_account, only: %i[show]
    before_action :authorize_account!, only: %i[show]

    def show; end

    def new
      @account = ErpCore::Account.new
    end

    def edit; end

    def create
      unless can_create_account?(current_user)
        # TODO: Revisar si se relaiza una doble peticion ya que puede que el cliente
        # no tenga account asociado y no sea owner
        # deberia redirigirlo al onboarding dashboard
        redirect_to erp_users.clients_dashboard_path, alert: I18n.l(unauthorized_create) and return
      end

      svc = ErpCore::CreateAccountService.new(user: current_user, params: account_params)
      result = svc.call

      if result.success
        flash[:notice] = I18n.l(created_successfully)
        redirect_to ErpAccounts::Engine.routes.url_helpers.account_path(result.account.id)
      else
        @account = result.account
        flash.now[:alert] = result.errors.join(", ")
        render :new, status: :unprocessable_content
      end
    end

    def settings; end
    def modules; end

    private

    def account_params
      params.require(:account).permit(:name, :subdomain)
    end

    def load_account
      if params[:id].present?
        @account = ErpCore::Account.find(params[:id])
        session[:current_account_id] = @account.id
      end
    end

    def can_create_account?(user)
      return false unless user.present?
      return true if user.new_without_roles_or_accounts?
      user.has_role?("owner")
    end

    def authorize_account!
      return redirect_to erp_users.clients_dashboard_path unless @account

      unless current_user.accounts.exists?(@account.id)
        redirect_to erp_users.clients_dashboard_path, alert: I18n.l(no_access)
      end
    end
  end
end
