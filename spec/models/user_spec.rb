require "spec_helper"

RSpec.describe Aypex::User do
  before(:all) { Aypex::Role.create name: "admin" }

  let!(:store) { create(:store) }

  it "#admin?" do
    expect(create(:admin_user).admin?).to be true
    expect(create(:user).admin?).to be false
  end

  describe ".admin_created?" do
    it "returns true when admin exists" do
      create(:admin_user)

      expect(described_class).to be_admin_created
    end

    it "returns false when admin does not exist" do
      expect(described_class).not_to be_admin_created
    end
  end

  describe "validations" do
    context "email" do
      let(:user) { build(:user, email: nil) }

      it "cannot be empty" do
        expect(user.valid?).to be false
        expect(user.errors.messages[:email].first).to eq "can't be blank"
      end
    end

    context "password" do
      let(:user) { build(:user, password: "pass1234", password_confirmation: "pass") }

      it "passwords has to be equal to password confirmation" do
        expect(user.valid?).to be false
        expect(user.errors.messages[:password_confirmation].first).to eq "doesn't match Password"
      end
    end
  end

  describe "#destroy" do
    it "will soft delete with uncompleted orders" do
      order = build(:order, store: store)
      order.save

      user = order.user
      user.destroy
      expect(Aypex::Config.user_class.find_by_id(user.id)).to be_nil
      expect(Aypex::Config.user_class.with_deleted.find_by_id(user.id).id).to eq(user.id)
      expect(Aypex::Config.user_class.with_deleted.find_by_id(user.id).orders.first).to eq(order)

      expect(Aypex::Order.find_by_user_id(user.id)).not_to be_nil
      expect(Aypex::Order.where(user_id: user.id).first).to eq(order)
    end

    it "will allow users to register later with same email address as previously deleted account" do
      user1 = build(:user, store: store)
      user1.save

      user2 = build(:user, store: store)
      user2.email = user1.email
      expect(user2.save).to be false
      expect(user2.errors.messages[:email].first).to eq "has already been taken"

      user1.destroy
      expect(user2.save).to be true
    end
  end

  describe "confirmable" do
    it "is confirmable if the confirmable option is enabled", confirmable: true do
      allow(Aypex::UserMailer).to receive(:confirmation_instructions).with(anything, anything, {current_store_id: Aypex::Store.default.id}).and_return(double(deliver: true))
      expect(Aypex::Config.user_class.devise_modules).to include(:confirmable)
    end

    it "is not confirmable if the confirmable option is disabled", confirmable: false do
      expect(Aypex::Config.user_class.devise_modules).not_to include(:confirmable)
    end
  end
end
