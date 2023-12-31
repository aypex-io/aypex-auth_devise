module Aypex
  module AuthDevise
    class SessionsController < Devise::SessionsController
      include Aypex::AuthDevise::Base

      def unauthorized
        return if try_aypex_current_user

        store_location
        redirect_to aypex.unauthorized_path
      end
    end
  end
end
