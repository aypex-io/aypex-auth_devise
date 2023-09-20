module Aypex
  module AuthDevise
    class SessionsController < Devise::SessionsController
      include Aypex::AuthDevise::Base

      def unauthorized
        return if try_aypex_current_user

        store_location
        redirect_to aypex.unauthorized_path
      end

      private

      default_form_builder(Aypex::AuthDevise::BootstrapBuilder)
    end
  end
end
