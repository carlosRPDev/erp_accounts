# frozen_string_literal: true

module ErpAccounts
  class AccountsController < ApplicationController
    layout "erp_accounts/application"

    before_action :authenticate_user!
    # before_action :set_account, only: [:edit, :update, :settings, :modules]
    # before_action :require_account_owner!, only: [:edit, :update, :settings, :modules]

    def index
      @accounts = current_user.accounts
    end

    def new
      @account = ErpCore::Account.new
    end

    def create
      @account = ErpCore::Account.new(account_params)
      @account.owner = current_user

      if @account.save
        @account.users << current_user
        redirect_to erp_accounts.accounts_path, notice: "Empresa creada correctamente"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end
    def settings; end
    def modules; end

    private

    def set_account
      @account = ErpCore::Account.find(params[:id])
    end

    def require_account_owner!
      return if @account.owner_id == current_user.id

      redirect_to erp_accounts.accounts_path,
                  alert: "No tienes permisos para administrar esta empresa."
    end

    def account_params
      params.require(:account).permit(:name)
    end
  end
end
