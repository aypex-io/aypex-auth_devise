module Aypex
  module AuthDevise
    class Configuration
      attr_writer :auth_layout_path, :signout_after_password_change, :validatable, :confirmable

      def auth_layout_path
        self.auth_layout_path = "application" unless @auth_layout_path

        if @auth_layout_path.is_a?(String)
          @auth_layout_path
        else
          raise "Aypex::AuthDevise::Config.auth_layout_path MUST be an String"
        end
      end

      def signout_after_password_change
        self.signout_after_password_change = true unless @signout_after_password_change == false

        if @signout_after_password_change.in? [true, false]
          @signout_after_password_change
        else
          raise "Aypex::AuthDevise::Config.signout_after_password_change MUST be a Boolean (true / false)"
        end
      end

      def validatable
        self.validatable = true unless @validatable == false

        if @validatable.in? [true, false]
          @validatable
        else
          raise "Aypex::AuthDevise::Config.validatable MUST be a Boolean (true / false)"
        end
      end

      def confirmable
        self.confirmable = false unless @confirmable == true

        if @confirmable.in? [true, false]
          @confirmable
        else
          raise "Aypex::AuthDevise::Config.confirmable MUST be a Boolean (true / false)"
        end
      end
    end
  end
end
