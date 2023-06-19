module Aypex
  module AuthDevise
    class UserPasswordsController < Devise::PasswordsController
      include Aypex::AuthDevise::Base
    end
  end
end
