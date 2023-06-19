module Aypex
  class UserMailer < BaseMailer
    def reset_password_instructions(user, token, opts = {})
      @user = user
      @current_store = current_store(opts)
      @edit_password_reset_url = edit_password_url(token, @current_store)

      mail to: user.email, from: from_address, reply_to: reply_to_address,
        subject: "#{@current_store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])}",
        store_url: @current_store.url
    end

    def confirmation_instructions(user, token, opts = {})
      @user = user
      @current_store = current_store(opts)
      @confirmation_url = aypex.aypex_user_confirmation_url(confirmation_token: token, host: @current_store.url)
      @email = user.email

      mail to: user.email, from: from_address, reply_to: reply_to_address,
        subject: "#{@current_store.name} #{I18n.t(:subject, scope: [:devise, :mailer, :confirmation_instructions])}",
        store_url: @current_store.url
    end

    protected

    def edit_password_url(token, store)
      aypex.edit_aypex_user_password_url(reset_password_token: token, host: store.url)
    end

    def current_store(opts = {})
      @current_store ||= Aypex::Store.find(opts[:current_store_id])
    end
  end
end
