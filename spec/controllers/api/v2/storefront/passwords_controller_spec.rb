require "spec_helper"

RSpec.describe Aypex::Api::V2::Storefront::PasswordsController do
  let(:store) { Aypex::Store.default }
  let(:user) { create(:user, store: store) }
  let(:password) { "new_password" }

  describe "POST create" do
    before { post :create, params: }

    context "when the user email has not been specified" do
      let(:params) { {user: {email: ""}} }

      it "responds with not found status" do
        expect(response.code).to eq("404")
      end
    end

    context "when the user email not found" do
      let(:params) { {user: {email: "dummy_email@example.com"}} }

      it "responds with not found status" do
        expect(response.code).to eq("404")
      end
    end

    context "when the user email has been specified" do
      let(:params) { {user: {email: user.email, store_id: store.id}} }

      it_behaves_like "returns 200 HTTP status"
    end
  end

  describe "PATCH update" do
    before { patch :update, params: }

    context "when updating password with blank password" do
      let(:params) do
        {
          id: user.send_reset_password_instructions,
          user: {
            password: "",
            password_confirmation: ""
          }
        }
      end

      it "responds with error" do
        expect(response.code).to eq("422")
        expect(JSON.parse(response.body)["error"]).to eq("Password can't be blank")
      end
    end

    context "when updating password with specified password" do
      let(:params) do
        {
          id: user.send_reset_password_instructions,
          user: {
            password:,
            password_confirmation: password
          }
        }
      end

      it_behaves_like "returns 200 HTTP status"
    end
  end
end
