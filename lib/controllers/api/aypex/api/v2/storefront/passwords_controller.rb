module Aypex
  module Api
    module V2
      module Storefront
        class PasswordsController < ::Aypex::Api::V2::BaseController
          include Aypex::ControllerHelpers::Store

          def create
            user = Aypex::Config.user_class.find_by(email: params[:user][:email], store_id: current_store.id.to_s)

            if user&.send_reset_password_instructions
              head :ok
            else
              head :not_found
            end
          end

          def update
            user = Aypex::Config.user_class.reset_password_by_token(
              password: params[:user][:password],
              password_confirmation: params[:user][:password_confirmation],
              reset_password_token: params[:id]
            )

            if user.errors.empty?
              head :ok
            else
              render json: {error: user.errors.full_messages.to_sentence}, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
