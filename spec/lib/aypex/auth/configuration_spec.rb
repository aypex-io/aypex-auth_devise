require "spec_helper"

RSpec.describe Aypex::AuthDevise::Configuration do
  subject(:test_subject) { Aypex::AuthDevise::Config }

  before { described_class.new }

  describe "#validatable" do
    after { test_subject.validatable = true }

    it "defaults to true" do
      expect(test_subject.validatable).to be true
    end

    it "is settable directly" do
      test_subject.validatable = false
      expect(test_subject.validatable).to be false
    end

    it "is settable via block" do
      Aypex::AuthDevise.configure do |config|
        config.validatable = false
      end

      expect(test_subject.validatable).to be false
    end

    it "returns error if not a Boolean" do
      test_subject.validatable = "string"
      expect { raise "Aypex::AuthDevise::Config.validatable MUST be a Boolean (true / false)" }.to raise_error(RuntimeError)
    end
  end

  describe "#signout_after_password_change" do
    after { test_subject.signout_after_password_change = true }

    it "defaults to true" do
      expect(test_subject.signout_after_password_change).to be true
    end

    it "is settable directly" do
      test_subject.signout_after_password_change = false
      expect(test_subject.signout_after_password_change).to be false
    end

    it "is settable via block" do
      Aypex::AuthDevise.configure do |config|
        config.signout_after_password_change = false
      end

      expect(test_subject.signout_after_password_change).to be false
    end

    it "returns error if not a Boolean" do
      test_subject.signout_after_password_change = "string"
      expect { raise "Aypex::AuthDevise::Config.signout_after_password_change MUST be a Boolean (true / false)" }.to raise_error(RuntimeError)
    end
  end

  describe "#confirmable" do
    after { test_subject.confirmable = false }

    it "defaults to false" do
      expect(test_subject.confirmable).to be false
    end

    it "is settable directly" do
      test_subject.confirmable = true
      expect(test_subject.confirmable).to be true
    end

    it "is settable via block" do
      Aypex::AuthDevise.configure do |config|
        config.confirmable = true
      end

      expect(test_subject.confirmable).to be true
    end

    it "returns error if not a Boolean" do
      test_subject.confirmable = "string"
      expect { raise "Aypex::AuthDevise::Config.confirmable MUST be a Boolean (true / false)" }.to raise_error(RuntimeError)
    end
  end
end
