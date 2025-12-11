# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ErpAccounts::Accounts", type: :request do
  let(:user) { create(:erp_core_user, :confirmed) }

  before { sign_in user }

  describe "GET /show" do
    context "when account exists and user has access" do
      let!(:account) { create(:erp_core_account) }

      before do
        user.accounts << account
      end

      it "loads account and sets session" do
        get erp_accounts.account_path(account.id)

        expect(response).to have_http_status(:success)
        expect(session[:current_account_id]).to eq(account.id)
      end
    end

    context "when account does not exist" do
      it "redirects to dashboard" do
        get erp_accounts.account_path(999_999_999)

        expect(response).to redirect_to(erp_users.clients_dashboard_path)
      end
    end

    context "when user has no access to account" do
      let!(:account) { create(:erp_core_account) }

      it "redirects with alert" do
        get erp_accounts.account_path(account.id)

        expect(response).to redirect_to(erp_users.clients_dashboard_path)
        expect(flash[:alert]).to eq(I18n.t("erp_accounts.accounts.no_access"))
      end
    end
  end

  describe "GET /new" do
    it "renders successfully" do
      get erp_accounts.new_account_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    let(:params) do
      { account: { name: "Test", subdomain: "demo" } }
    end

    let(:service_double) { instance_double(ErpCore::CreateAccountService) }

    before do
      allow(ErpCore::CreateAccountService).to receive(:new).and_return(service_double)
    end

    context "when user cannot create account" do
      before do
        allow_any_instance_of(ErpAccounts::AccountsController)
          .to receive(:can_create_account?).and_return(false)
      end

      it "redirects to dashboard with alert" do
        post erp_accounts.accounts_path, params: params

        expect(response).to redirect_to(erp_users.clients_dashboard_path)
        expect(flash[:alert]).to eq(I18n.t("erp_accounts.accounts.unauthorized_create"))
      end
    end

    context "when creation is successful" do
      let(:new_account) { create(:erp_core_account) }

      before do
        allow_any_instance_of(ErpAccounts::AccountsController)
          .to receive(:can_create_account?).and_return(true)

        allow(service_double).to receive(:call).and_return(
          ErpCore::CreateAccountService::Result.new(true, new_account, nil)
        )
      end

      it "redirects to the account page" do
        post erp_accounts.accounts_path, params: params

        expect(response).to redirect_to(erp_accounts.account_path(new_account.id))
      end
    end

    context "when creation fails" do
      let(:invalid_account) { build(:erp_core_account, name: nil) }

      before do
        allow_any_instance_of(ErpAccounts::AccountsController)
          .to receive(:can_create_account?).and_return(true)

        allow(service_double).to receive(:call).and_return(
          ErpCore::CreateAccountService::Result.new(false, invalid_account, [ "Name no puede estar en blanco" ])
        )
      end

      it "renders new with errors" do
        post erp_accounts.accounts_path, params: params

        expect(response.body).to include("Name no puede estar en blanco")
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
