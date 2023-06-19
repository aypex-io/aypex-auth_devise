module Aypex
  class UserConfirmationsController < Devise::ConfirmationsController
    include Aypex::Auth::Base
  end
end
