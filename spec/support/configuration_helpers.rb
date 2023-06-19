module ConfigurationHelpers
  def allow_bypass_sign_in
    Aypex::AuthDevise::Config.signout_after_password_change = false
  end
end

RSpec.configure do |config|
  config.include ConfigurationHelpers
end
