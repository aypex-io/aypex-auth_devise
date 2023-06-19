module Aypex
  module AuthenticationHelpers
    def self.included(receiver)
      receiver.send :helper_method, :aypex_account_path
      receiver.send :helper_method, :aypex_current_user
      receiver.send :helper_method, :aypex_login_path
      receiver.send :helper_method, :aypex_logout_path
      receiver.send :helper_method, :aypex_signup_path
      receiver.send :helper_method, :aypex_unauthorized_path
    end

    def aypex_current_user
      current_aypex_user
    end

    def aypex_account_path(opts = {})
      aypex.account_path(opts)
    end

    def aypex_login_path(opts = {})
      aypex.new_aypex_user_session_path(opts)
    end

    def aypex_logout_path(opts = {})
      aypex.destroy_aypex_user_session_path(opts)
    end

    def aypex_signup_path(opts = {})
      aypex.new_aypex_user_registration_path(opts)
    end

    def aypex_unauthorized_path(opts = {})
      aypex.unauthorized_path(opts)
    end
  end
end
