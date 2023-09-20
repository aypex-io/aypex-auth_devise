module Aypex
  class UsersController < Aypex::StoreController
    include Aypex::ControllerHelpers

    before_action :load_user
    prepend_before_action :authorize_actions, only: :new

    def show
      @orders = @user.orders.for_store(current_store).complete.order("completed_at desc")
    end

    def edit
    end

    def update
      if @user.update_without_password(user_params)
        redirect_to aypex_account_path, notice: I18n.t("aypex.auth_devise.account_updated")
      else
        render action: :edit, status: :unprocessable_entity
      end
    end

    def update_password
      if @user.update_with_password(user_params)
        bypass_sign_in @user, scope: resource_name if sign_in_after_change_password?
        redirect_to aypex_account_path, notice: I18n.t("aypex.auth_devise.account_updated")
      else
        # @user.errors.add(:existing_password, I18n.t("aypex.auth_devise.existing_password_incorrect"))
        render action: :edit, status: :unprocessable_entity
      end
    end

    private

    default_form_builder(Aypex::AuthDevise::BootstrapBuilder)

    def user_params
      permitted_attributes = Aypex::PermittedAttributes.user_attributes
      params.require(:user).permit(permitted_attributes)
    end

    def load_user
      @user ||= try_aypex_current_user
      authorize! params[:action].to_sym, @user
    end

    def authorize_actions
      authorize! params[:action].to_sym, Aypex::Config.user_class.new
    end

    def accurate_title
      I18n.t("aypex.auth_devise.my_account")
    end
  end
end
