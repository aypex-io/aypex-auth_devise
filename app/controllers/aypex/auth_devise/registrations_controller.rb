module Aypex
  module AuthDevise
    class RegistrationsController < Devise::RegistrationsController
      include Aypex::AuthDevise::Base

      private

      default_form_builder(Aypex::AuthDevise::BootstrapBuilder)

      def sign_up_params
        user_params = params.require(resource_name).permit(Aypex::PermittedAttributes.user_attributes)
        user_params[:selected_locale] ||= current_locale
        user_params[:store_id] = current_store.id

        user_params
      end
    end
  end
end
