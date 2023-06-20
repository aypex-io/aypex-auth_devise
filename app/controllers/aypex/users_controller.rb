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
      if @user.update!(user_params)
        redirect_to aypex_account_path, notice: I18n.t("aypex.auth_devise.account_updated")
      else
        render action: :edit, status: :unprocessable_entity
      end
    end

    def update_password
      permitted_params = params.require(:user).permit([:existing_password, :password, :password_confirmation])

      # Ensure that all password fields are populated with
      # at least an empty string, this triggers the full validations
      # otherwise a user could reset the password with nil in the password_confirmation
      # field by using developer tools to delete the password_confirmation field.
      existing_password = permitted_params[:existing_password] || ""
      new_password = permitted_params[:password] || ""
      new_password_confirmation = if Aypex::AuthDevise::Config.use_password_confirm_field
        permitted_params[:password_confirmation] || ""
      else
        permitted_params[:password_confirmation]
      end

      if @user.valid_password?(existing_password)
        if @user.reset_password(new_password, new_password_confirmation)
          redirect_to aypex_account_path, notice: I18n.t("aypex.auth_devise.password_updated")
        else
          flash[:notice] = I18n.t("aypex.auth_devise.password_error")
          render action: :edit, status: :unprocessable_entity
        end
      else
        @user.errors.add(:existing_password, I18n.t("aypex.auth_devise.existing_password_incorrect"))
        render action: :edit, status: :unprocessable_entity
      end
    end

    private

    def user_params
      permitted_attributes = Aypex::PermittedAttributes.user_attributes - [:password, :password_confirmation]
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
