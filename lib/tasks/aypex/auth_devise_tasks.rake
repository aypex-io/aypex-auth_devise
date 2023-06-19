namespace :aypex do
  namespace :auth_devise do
    desc "Create admin username and password"
    task create_admin: :environment do
      require File.join(File.dirname(__FILE__), "..", "..", "..", "db", "default", "users.rb")
      puts "Done!"
    end
  end
end
