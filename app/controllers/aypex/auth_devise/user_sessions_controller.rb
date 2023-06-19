module Aypex
  class UserSessionsController < Devise::SessionsController
    include Aypex::Auth::Base

    def unauthorized
      return if try_aypex_current_user

      store_location
      redirect_to aypex.unauthorized_path
    end
  end
end
