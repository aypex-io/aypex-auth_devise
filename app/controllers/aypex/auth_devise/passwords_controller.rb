module Aypex
  module AuthDevise
    class PasswordsController < Devise::PasswordsController
      include Aypex::AuthDevise::Base

      private

      default_form_builder(Aypex::AuthDevise::BootstrapBuilder)
    end
  end
end
