module Aypex
  class UserRegistrationsController < Devise::RegistrationsController
    include Aypex::Auth::Base

    private

    def sign_up_params
      user_params = params.require(resource_name).permit(Aypex::PermittedAttributes.user_attributes)
      user_params[:selected_locale] ||= current_locale
      user_params[:store_id] = current_store.id

      user_params
    end
  end
end
