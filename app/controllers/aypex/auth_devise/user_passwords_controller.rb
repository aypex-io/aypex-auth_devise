module Aypex
  class UserPasswordsController < Devise::PasswordsController
    include Aypex::Auth::Base
  end
end
