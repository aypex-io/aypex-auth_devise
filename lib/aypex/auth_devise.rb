require "aypex/auth_devise/version"
require "aypex/auth_devise/engine"

require "aypex"
require "aypex/authentication_helpers"
require "devise"
require "cancan"
require "inline_svg"
require "responders"
require "turbo-rails"

module Aypex
  module AuthDevise
    mattr_accessor :default_secret_key

    def self.configure
      yield(Aypex::AuthDevise::Config)
    end
  end
end

Devise.secret_key = SecureRandom.hex(50)
Aypex::AuthDevise.default_secret_key = Devise.secret_key
