require "highline/import"

# see last line where we create an admin if there is none, asking for email and password
def prompt_for_admin_password
  if ENV["ADMIN_PASSWORD"]
    password = ENV["ADMIN_PASSWORD"].dup
    say "Admin Password #{password}"
  else
    password = ask("Password [Aypex-123!]: ") do |q|
      q.echo = false
      q.validate = /^(|.{6,40})$/
      q.responses[:not_valid] = "Invalid password. Must be at least 6 characters long."
      q.whitespace = :strip
    end
    password = "Aypex-123!" if password.blank?
  end

  password
end

def prompt_for_admin_email
  if ENV["ADMIN_EMAIL"]
    email = ENV["ADMIN_EMAIL"].dup
    say "Admin User #{email}"
  else
    email = ask("Email [admin@aypex.io]: ") do |q|
      q.echo = true
      q.whitespace = :strip
    end
    email = "admin@aypex.io" if email.blank?
  end

  email
end

def create_admin_user
  if ENV["AUTO_ACCEPT"]
    password = "Aypex-123!"
    email = "admin@aypex.io"
  else
    puts "Create the admin user (press enter for defaults)."
    # name = prompt_for_admin_name unless name
    email = prompt_for_admin_email
    password = prompt_for_admin_password
  end
  attributes = {
    password:,
    password_confirmation: password,
    email:,
    login: email,
    store: Aypex::Store.default
  }

  if Aypex::User.find_by_email(email)
    say "\nWARNING: There is already a user with the email: #{email}, so no account changes were made.  If you wish to create an additional admin user, please run rake aypex_auth:admin:create again with a different email.\n\n"
  else
    admin = Aypex::User.new(attributes)
    if admin.save
      role = Aypex::Role.find_or_create_by(name: "admin")
      admin.aypex_roles << role
      admin.save
      admin.generate_aypex_api_key! if Aypex::Auth::Engine.api_available?
      say "Done!"
    else
      say "There was some problems with persisting new admin user:"
      admin.errors.full_messages.each do |error|
        say error
      end
    end
  end
end

if Aypex::User.admin.empty?
  create_admin_user
else
  puts "Admin user has already been previously created."
  if agree("Would you like to create a new admin user? (yes/no)")
    create_admin_user
  else
    puts "No admin user created."
  end
end
