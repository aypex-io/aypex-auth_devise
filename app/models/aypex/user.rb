module Aypex
  class User < Aypex::Base
    include UserAddress
    include UserMethods
    include UserPaymentSource
    include Metadata if defined?(Aypex::Metadata)

    scoped_by_keys = [:email, :store_id]

    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable
    devise :confirmable, confirmation_keys: scoped_by_keys if Aypex::AuthDevise::Config.confirmable
    devise :validatable if Aypex::AuthDevise::Config.validatable
    devise authentication_keys: scoped_by_keys, reset_password_keys: scoped_by_keys

    acts_as_paranoid
    after_destroy :scramble_email_and_password

    roles_table_name = Role.table_name

    scope :admin, -> { includes(:aypex_roles).where("#{roles_table_name}.name" => "admin") }

    def self.admin_created?
      User.admin.exists?
    end

    def admin?
      has_aypex_role?("admin")
    end

    def send_confirmation_instructions
      unless @raw_confirmation_token
        generate_confirmation_token!
      end

      opts = pending_reconfirmation? ? {to: unconfirmed_email} : {}
      opts[:current_store_id] = store_id
      send_devise_notification(:confirmation_instructions, @raw_confirmation_token, opts)
    end

    def send_reset_password_instructions_notification(token)
      send_devise_notification(:reset_password_instructions, token, {current_store_id: store_id})
    end

    private

    def scramble_email_and_password
      self.email = "#{SecureRandom.uuid}@example.net"
      self.password = SecureRandom.hex(8)
      self.password_confirmation = password

      save
    end
  end
end
