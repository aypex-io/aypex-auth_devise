module Aypex
  module AuthDevise
    class UserConfirmationsController < Devise::ConfirmationsController
      include Aypex::AuthDevise::Base
    end
  end
end
