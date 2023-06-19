module Aypex
  module AuthDevise
    class PasswordsController < Devise::PasswordsController
      include Aypex::AuthDevise::Base
    end
  end
end
