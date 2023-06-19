require "spec_helper"

RSpec.describe Aypex::AuthDevise::RegistrationsController do
  after { I18n.locale = :en }

  describe "#create" do
    it "redirects to account_path" do
      post :create, params: {aypex_user: {email: "foobar@example.com", password: "foobar123", password_confirmation: "foobar123"}}
      expect(response).to redirect_to aypex.root_path
    end

    context "with non default locale" do
      before do
        Aypex::Store.default.update(default_locale: "en", supported_locales: "en,fr,it")
      end

      it "redirects to root_path with locale" do
        post :create, params: {aypex_user: {email: "foobar@example.com", password: "foobar123", password_confirmation: "foobar123"}, locale: :fr}
        expect(response).to redirect_to aypex.root_path(locale: :fr)
      end

      context "stores the users preferred locale" do
        it "when user selects a language" do
          post :create, params: {aypex_user: {email: "foobar@example.com", password: "foobar123", password_confirmation: "foobar123", selected_locale: :it}, locale: :fr}
          user = Aypex::Config.user_class.find_by_email("foobar@example.com")
          expect(user.selected_locale).to eq("it")
        end

        it "when language is not the default" do
          post :create, params: {aypex_user: {email: "foobar@example.com", password: "foobar123", password_confirmation: "foobar123"}, locale: :fr}
          user = Aypex::Config.user_class.find_by_email("foobar@example.com")
          expect(user.selected_locale).to eq("fr")
        end
      end
    end

    context "with a guest token present" do
      before do
        request.cookie_jar.signed[:token] = "ABC"
      end

      it "assigns orders with the correct token and no user present" do
        order = create(:order, token: "ABC", user_id: nil, created_by_id: nil)

        post :create, params: {aypex_user: {email: "foobar@example.com", password: "foobar123", password_confirmation: "foobar123"}}
        user = Aypex::Config.user_class.find_by_email("foobar@example.com")

        order.reload
        expect(order.user_id).to eq user.id
        expect(order.created_by_id).to eq user.id
      end

      it "does not assign orders with an existing user" do
        order = create(:order, token: "ABC", user_id: 200)

        post :create, params: {aypex_user: {email: "foobar@example.com", password: "foobar123", password_confirmation: "foobar123"}}

        expect(order.reload.user_id).to eq 200
      end

      it "does not assign orders with a different token" do
        order = create(:order, token: "DEF", user_id: nil, created_by_id: nil)

        post :create, params: {aypex_user: {email: "foobar@example.com", password: "foobar123", password_confirmation: "foobar123"}}

        expect(order.reload.user_id).to be_nil
      end
    end
  end

  context "when user session times out" do
    let(:user) { build_stubbed(:user) }

    before do
      Aypex::Store.default.update(default_locale: "en", supported_locales: "en,fr")
      allow(Devise::Mapping).to receive(:find_scope!).and_return(:aypex_user)
    end

    it "redirects to sign in after timeout" do
      expect(controller.send(:after_inactive_sign_up_path_for, :user)).to eq(aypex.root_path)
    end

    context "with locale changed to fr" do
      before do
        allow(controller).to receive(:locale_param).and_return("fr")
      end

      it "redirect to sign in after timeout with changed locale" do
        expect(controller.send(:after_inactive_sign_up_path_for, :user)).to eq(aypex.root_path("fr"))
      end
    end
  end
end
