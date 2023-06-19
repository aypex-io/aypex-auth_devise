module Aypex
  module AuthDevise
    class ConfirmationsController < Devise::ConfirmationsController
      include Aypex::AuthDevise::Base
    end
  end
end
