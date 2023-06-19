module Aypex
  module AuthDevise
    module Generators
      class InstallGenerator < Rails::Generators::Base
        class_option :migrate, type: :boolean, default: true, banner: "Migrate the database"

        def self.source_paths
          paths = superclass.source_paths
          paths << File.expand_path("templates", __dir__)
          paths.flatten
        end

        def generate_devise_key
          template "config/initializers/devise.rb", "config/initializers/devise.rb"
        end

        def add_migrations
          run "bundle exec rake railties:install:migrations FROM=aypex_auth"
        end

        def run_migrations
          if options[:migrate]
            run "bundle exec rake db:migrate VERBOSE=false"
          else
            puts "Skipping rake db:migrate, don't forget to run it!"
          end
        end
      end
    end
  end
end
