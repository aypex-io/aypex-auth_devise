require_relative "configuration"

module Aypex
  module AuthDevise
    class Engine < Rails::Engine
      isolate_namespace Aypex
      engine_name "aypex_auth_devise"

      initializer "aypex.auth_devise.environment", before: :load_config_initializers do
        Aypex::AuthDevise::Config = Aypex::AuthDevise::Configuration.new
      end

      initializer "aypex-auth_devise.set_user_class", after: :load_config_initializers do
        Aypex::Config.user_class = "Aypex::User"
      end

      initializer "aypex-auth_devise.check_secret_token" do
        if Aypex::AuthDevise.default_secret_key == Devise.secret_key
          puts "[WARNING] You are not setting Devise.secret_key within your application!"
          puts "You must set this in config/initializers/devise.rb. Here's an example:"
          puts " "
          puts %(Devise.secret_key = "#{SecureRandom.hex(50)}")
        end
      end

      def self.admin_available?
        @@admin_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Admin::Engine")
      end

      def self.api_available?
        @@api_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Api::Engine")
      end

      def self.checkout_available?
        @@checkout_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Checkout::Engine")
      end

      def self.emails_available?
        @@emails_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Emails::Engine")
      end

      def self.storefront_available?
        @@storefront_available ||= ::Rails::Engine.subclasses.map(&:instance).map { |e| e.class.to_s }.include?("Aypex::Storefront::Engine")
      end

      def self.activate
        ::ApplicationController.include Aypex::AuthenticationHelpers
      end

      if api_available?
        paths["app/controllers"] << "lib/controllers/api"
      end

      if emails_available?
        paths["app/views"] << "lib/views/emails"
        paths["app/mailers"] << "lib/mailers"
      end

      config.to_prepare(&method(:activate).to_proc)
    end
  end
end
