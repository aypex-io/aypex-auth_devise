require "spec_helper"

RSpec.describe Aypex::AuthDevise::PasswordsController do
  let(:token) { "some_token" }

  describe "GET edit" do
    context "when the user token has not been specified" do
      it "redirects to the new session path" do
        get :edit

        expect(response).to redirect_to(
          "http://test.host/accounts/sign_in"
        )
      end

      it "flashes an error" do
        get :edit
        expect(flash[:alert]).to include(
          "You can't access this page without coming from a password reset " \
          "email"
        )
      end
    end

    context "when the user token has been specified" do
      it "does something" do
        get :edit, params: {reset_password_token: token}
        expect(response.code).to eq("200")
      end
    end
  end

  describe "#update" do
    context "when updating password with blank password" do
      it "shows error flash message, sets aypex_user with token and re-displays password edit form" do
        put :update, params: {aypex_user: {password: "", password_confirmation: "", reset_password_token: token}}
        expect(assigns(:aypex_user).is_a?(Aypex::User)).to be true
        expect(assigns(:aypex_user).reset_password_token).to eq token
        # TODO: expect(flash[:error]).to eq "Password cannot be blank"
        expect(response).to render_template :edit
      end
    end
  end
end
