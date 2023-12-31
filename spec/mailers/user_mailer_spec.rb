require "spec_helper"

RSpec.describe Aypex::UserMailer do
  let(:user) { create(:user) }
  let(:store) { Aypex::Store.default }

  describe "#reset_password_instructions" do
    describe "message contents" do
      before do
        @message = described_class.reset_password_instructions(user, "token goes here", {current_store_id: Aypex::Store.default.id})
      end

      context "subject includes" do
        it "translated devise instructions" do
          expect(@message.subject).to include(
            I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])
          )
        end

        it "Aypex site name" do
          expect(@message.subject).to include store.name
        end
      end

      context "body includes" do
        it "password reset url" do
          expect(@message.body.encoded).to include "http://#{store.url}/accounts/password/edit"
        end
      end
    end

    describe "legacy support for User object" do
      it "sends an email" do
        expect do
          described_class.reset_password_instructions(user, "token goes here", {current_store_id: Aypex::Store.default.id}).deliver_now
        end.to change(ActionMailer::Base.deliveries, :size).by(1)
      end
    end
  end
end
