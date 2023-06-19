require "spec_helper"

RSpec.describe Aypex::AuthDevise::UserSessionsController do
  let!(:store) { create(:store) }
  let!(:store_two) { create(:store) }
  let(:user) { create(:user, store: store) }
  let(:user_alt_store) { create(:user, store: store_two) }

  after { I18n.locale = :en }

  describe "#create" do
    context "using correct login information" do
      # regression tests for https://github.com/aypex/aypex_auth_devise/pull/438
      context "with a token present" do
        before do
          request.cookie_jar.signed[:token] = "ABC"
        end

        it "assigns orders with the correct token and no user present" do
          order = create(:order, email: user.email, token: "ABC", user_id: nil, created_by_id: nil)

          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it "assigns orders with the correct token and no user or email present" do
          order = create(:order, token: "ABC", user_id: nil, created_by_id: nil)
          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it "does not assign completed orders" do
          order = create(:order, email: user.email, token: "ABC",
            user_id: nil, created_by_id: nil,
            completed_at: 1.minute.ago)
          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          order.reload
          expect(order.user_id).to be_nil
          expect(order.created_by_id).to be_nil
        end

        it "does not assign orders with an existing user" do
          order = create(:order, token: "ABC", user_id: 200)
          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          expect(order.reload.user_id).to eq 200
        end

        it "does not assign orders with a different token" do
          order = create(:order, token: "DEF", user_id: nil, created_by_id: nil)
          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          expect(order.reload.user_id).to be_nil
        end
      end

      context "with a guest token present" do
        before do
          request.cookie_jar.signed[:token] = "ABC"
        end

        it "assigns orders with the correct token and no user present" do
          order = create(:order, email: user.email, token: "ABC", user_id: nil, created_by_id: nil)
          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it "assigns orders with the correct token and no user or email present" do
          order = create(:order, token: "ABC", user_id: nil, created_by_id: nil)

          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          order.reload
          expect(order.user_id).to eq user.id
          expect(order.created_by_id).to eq user.id
        end

        it "does not assign completed orders" do
          order = create(:order, email: user.email, token: "ABC",
            user_id: nil, created_by_id: nil,
            completed_at: 1.minute.ago)

          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          order.reload
          expect(order.user_id).to be_nil
          expect(order.created_by_id).to be_nil
        end

        it "does not assign orders with an existing user" do
          order = create(:order, token: "ABC", user_id: 200)

          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          expect(order.reload.user_id).to eq 200
        end

        it "does not assign orders with a different token" do
          order = create(:order, token: "DEF", user_id: nil, created_by_id: nil)

          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}

          expect(order.reload.user_id).to be_nil
        end
      end

      it "redirects to root path after signing in" do
        post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}
        expect(response).to redirect_to aypex.root_path
      end

      context "with a different locale" do
        before do
          Aypex::Store.default.update(default_locale: "en", supported_locales: "en,fr")
        end

        it "redirects to localized account path after signing in" do
          post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}, locale: :fr}
          expect(response).to redirect_to aypex.root_path(locale: :fr)
        end
      end
    end

    context "using incorrect login information" do
      it "renders new template again with errors" do
        post :create, params: {aypex_user: {email: user.email, password: "wrong", store_id: store.id}}

        expect(response).to have_http_status(:unprocessable_entity)
        # TODO: expect(flash[:error]).to eq I18n.t(:"devise.failure.invalid")
      end
    end

    context "when user tries to log into a store they are not associated with" do
      it "renders new template again with errors" do
        post :create, params: {aypex_user: {email: user_alt_store.email, password: "secret", store_id: store.id}}

        expect(response).to have_http_status(:unprocessable_entity)
        # TODO: expect(flash[:error]).to eq I18n.t(:"devise.failure.invalid")
      end
    end
  end

  describe "#destroy" do
    before do
      Aypex::Store.default.update(default_locale: "en", supported_locales: "en,fr")
    end

    it "redirects to login page after signing out with default locale" do
      post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}}
      delete :destroy
      expect(response).to redirect_to(aypex.root_path)
    end

    it "persists fr locale when redirecting to login page after signing out" do
      post :create, params: {aypex_user: {email: user.email, password: "secret", store_id: store.id}, locale: :fr}
      delete :destroy, params: {locale: :fr}
      expect(response).to redirect_to aypex.root_path(locale: :fr)
    end
  end
end
