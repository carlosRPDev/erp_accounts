# frozen_string_literal: true

require "rails_helper"

RSpec.describe ErpAccounts::CashierToday::BaseComponent, type: :component do
  let(:account) { create(:erp_core_account) }
  let(:user) { create(:erp_core_user, :confirmed) }
  let(:component) { described_class.new(current_user: user, account: account) }

  describe "#visible_for_roles?" do
    context "when user has one of the given roles" do
      before do
        user.add_role(:cashier, account: account)
      end

      it "returns true" do
        expect(component.visible_for_roles?(:owner, :cashier)).to be(true)
      end
    end

    context "when user has none of the given roles" do
      it "returns false" do
        expect(component.visible_for_roles?(:owner, :manager)).to be(false)
      end
    end
  end

  describe "#totals" do
    it "returns the fixed totals hash" do
      expect(component.totals).to eq(
        total_in_box: 150_000,
        sales_count: 28,
        diffs: 0
      )
    end
  end
end
