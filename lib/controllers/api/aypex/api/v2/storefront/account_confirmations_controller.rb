module Aypex
  module Api
    module V2
      module Storefront
        class AccountConfirmationsController < ::Aypex::Api::V2::BaseController
          def show
            user = Aypex::Config.user_class.confirm_by_token(params[:id])

            if user.errors.empty?
              render json: {data: {state: user.respond_to?(:state) ? user.state : ""}}, status: :ok
            else
              render json: {error: user.errors.full_messages.to_sentence}, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
