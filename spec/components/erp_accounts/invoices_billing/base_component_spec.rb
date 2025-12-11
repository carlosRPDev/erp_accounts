# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErpAccounts::InvoicesBilling::BaseComponent, type: :component do
  let(:account) { create(:erp_core_account) }
  let(:user) { create(:erp_core_user, :confirmed) }
  let(:component) { described_class.new(current_user: user, account: account) }

  describe "#visible_for?" do
    context "when the user has the given role" do
      before do
        user.add_role(:billing, account: account)
      end

      it "returns true" do
        expect(component.visible_for?(:billing)).to be(true)
      end
    end

    context "when the user does not have the given role" do
      it "returns false" do
        expect(component.visible_for?(:billing)).to be(false)
      end
    end
  end

  describe "#stats" do
    it "returns the fixed stats hash" do
      expect(component.stats).to eq(
        emitted: 24,
        pending: 5
      )
    end
  end
end
