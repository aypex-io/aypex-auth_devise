require "spec_helper"

RSpec.describe Aypex::Order do
  let(:order) { described_class.new }

  describe "#associate_user!" do
    let(:user) { build_stubbed(:user, email: "aypex@example.com") }

    before { allow(order).to receive(:save!).and_return(true) }

    it "associates the order with the specified user" do
      order.associate_user! user
      expect(order.user).to eq user
    end

    it "sets the order's email attribute to that of the specified user" do
      order.associate_user! user
      expect(order.email).to eq user.email
    end

    it "destroys any previous association with a guest user" do
      guest_user = build_stubbed(:user)
      order.user = guest_user
      order.associate_user! user
      expect(order.user).not_to eq guest_user
    end
  end
end
