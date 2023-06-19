require "spec_helper"

RSpec.describe Aypex::UsersController do
  let(:admin_user) { create(:user) }
  let!(:user) { create(:user) }
  let(:role) { create(:role) }

  before do
    allow(controller).to receive(:try_aypex_current_user) { user }
    Aypex::Store.default.update(default_locale: "en", supported_locales: "en,fr")
  end

  after { I18n.locale = :en }

  describe "#load_object" do
    it "redirects to signup path if user is not found" do
      allow(controller).to receive(:try_aypex_current_user).and_return(nil)
      put :update, params: {user: {email: "foobar@example.com"}}

      expect(response).to redirect_to aypex.new_aypex_user_session_path
    end

    context "non default locale" do
      it "redirects to signup path with non default locale if user is not found" do
        allow(controller).to receive(:try_aypex_current_user).and_return(nil)
        put :update, params: {user: {email: "foobar@example.com"}, locale: :fr}
        expect(response).to redirect_to aypex.new_aypex_user_session_path(locale: :fr)
      end
    end
  end

  describe "#update" do
    context "when updating own account" do
      context "default locale" do
        before {
          put :update, params: {
            user: {
              email: "my-new@email-address.com"
            }
          }
        }

        it "performs update of email" do
          expect(user.email).to eq "my-new@email-address.com"
        end

        it "redirects to correct path" do
          expect(response).to redirect_to aypex.account_path
        end
      end

      context "non default locale" do
        before { put :update, params: {user: {email: "mynew@email-address.com"}, locale: :fr} }

        it "performs update of email" do
          expect(user.email).to eq "mynew@email-address.com"
        end

        it "persists locale when redirecting to account" do
          expect(response).to redirect_to aypex.account_path(locale: :fr)
        end
      end

      it "performs update of selected_locale" do
        put :update, params: {user: {selected_locale: "pl"}}

        expect(user.selected_locale).to eq "pl"
      end
    end

    it "does not update roles" do
      put :update, params: {user: {aypex_role_ids: [role.id]}}

      expect(user.aypex_roles).not_to include role
    end
  end
end
