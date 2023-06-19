Devise.setup do |config|
  require "devise/orm/active_record"

  config.mailer = "Aypex::UserMailer" if defined?(Aypex::Emails)
  config.http_authenticatable = true
  config.http_authentication_realm = "Aypex Application"
  config.stretches = Rails.env.test? ? 1 : 12
  config.reset_password_within = 6.hours
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.email_regexp = /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/
  config.reconfirmable = true
  config.skip_session_storage = []
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
