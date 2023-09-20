module Aypex
  module AuthDevise
    class ConfirmationsController < Devise::ConfirmationsController
      include Aypex::AuthDevise::Base

      private

      default_form_builder(Aypex::AuthDevise::BootstrapBuilder)
    end
  end
end
