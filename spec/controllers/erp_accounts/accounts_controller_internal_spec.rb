# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErpAccounts::AccountsController, type: :controller do
  let(:user) { build(:erp_core_user) }

  describe "#can_create_account?" do
    it "returns true when user is new_without_roles_or_accounts?" do
      allow(user).to receive(:new_without_roles_or_accounts?).and_return(true)

      expect(controller.send(:can_create_account?, user)).to be(true)
    end

    it "returns true when user has owner role" do
      allow(user).to receive_messages(
        new_without_roles_or_accounts?: false,
        has_role?: false
      )

      allow(user).to receive(:has_role?).with("owner").and_return(true)

      expect(controller.send(:can_create_account?, user)).to be(true)
    end

    it "returns false when user is not new and not owner" do
      allow(user).to receive_messages(
        new_without_roles_or_accounts?: false,
        has_role?: false
      )

      expect(controller.send(:can_create_account?, user)).to be(false)
    end
  end
end
