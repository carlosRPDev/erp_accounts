# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErpAccounts::WorkersModuleCard::BaseComponent, type: :component do
  let(:account) { create(:erp_core_account) }
  let(:user) { create(:erp_core_user, :confirmed) }

  describe "#visible?" do
    context "when user has owner role for the account" do
      before do
        user.add_role(:owner, account: account)
      end

      it "returns true" do
        component = described_class.new(current_user: user, account: account)

        expect(component.visible?).to be(true)
      end
    end

    context "when user does not have owner role" do
      it "returns false" do
        component = described_class.new(current_user: user, account: account)

        expect(component.visible?).to be(false)
      end
    end
  end

  describe "#workers_path" do
    it "returns the workers index path for the account" do
      component = described_class.new(current_user: user, account: account)

      expected_path =
        ErpWorkers::Engine.routes.url_helpers.accounts_workers_path(
          account_id: account.id
        )

      expect(component.workers_path).to eq(expected_path)
    end
  end
end
