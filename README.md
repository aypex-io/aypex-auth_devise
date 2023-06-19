[![CI Test Suite](https://github.com/aypex-io/aypex-auth_devise/actions/workflows/ci.yml/badge.svg)](https://github.com/aypex-io/aypex-auth_devise/actions/workflows/ci.yml)
[![Lint Ruby Formatting](https://github.com/aypex-io/aypex-auth_devise/actions/workflows/standard_rb.yml/badge.svg)](https://github.com/aypex-io/aypex-auth_devise/actions/workflows/standard_rb.yml)
[![SNYK Gem Dependency](https://github.com/aypex-io/aypex-auth_devise/actions/workflows/snyk.yml/badge.svg)](https://github.com/aypex-io/aypex-auth_devise/actions/workflows/snyk.yml)

# Aypex::AuthDevise
Adds Sign In / Sign Out + Accounts to Aypex

## Installation

1. Add this extension to your Gemfile with this line:

```ruby
gem 'aypex-auth_devise'
```

2. Install the gem using Bundler:
```bash
bundle install
```

3. Copy & run migrations:
```bash
bundle exec rails g aypex:auth_devise:install
```

### Create a default Admin user

To create an Admin user, run this rake task:

```bash
bundle exec rake aypex:auth_devise:create_admin
```
If you are doing this for the first time in production, it is recommended that you have your application emails set up and deliverable. Ensure Confirmable is set to true as detailed below, guaranteeing your new admin user can be confirmed.


## Configuration

### Confirmable

When in production, it is highly recommended that you enable Devise's Confirmable module, which will send new users an email containing a link to confirm their account.

Add this line to an initializer in your Rails project (typically `config/initializers/aypex.rb`):
```ruby
Aypex::AuthDevise::Config.confirmable = true
```

Add a Devise initializer to your Rails project (typically `config/initializers/devise.rb`):
```ruby
Devise.setup do |config|
  # Required so users don't lose their carts when they need to confirm.
  config.allow_unconfirmed_access_for = 3.days
end
```

### Sign out after password change

To disable sign out after password change you must add this line to an initializer in your Rails project (typically `config/initializers/aypex.rb`):

```ruby
Aypex::AuthDevise::Config.signout_after_password_change = false
```

## Using in an existing Rails application

If you are installing Aypex inside of a host application in which you want your own permission setup, you can do this using aypex_auth_devise's register_ability method.

First create your own CanCan Ability class following the CanCan documentation.

For example: app/models/your_ability_class.rb

```ruby
class YourAbilityClass
  include CanCan::Ability

  def initialize user
    # direct permissions
     can :create, SomeRailsObject

     # or permissions by group
     if aypex_user.has_aypex_role? "admin"
       can :create, SomeRailsAdminObject
     end
   end
end
```

Then register your class in your aypex initializer: config/initializers/aypex.rb
```ruby
Aypex::Ability.register_ability(YourAbilityClass)
```

Inside of your host application you can then use CanCan like you normally would.
```ruby
if can? :show, SomeRailsObject
```

## Testing

You need to do a quick one-time creation of a test application and then you can use it to run the tests.
```bash
bundle exec rake test_app
```

Then run the rspec tests.
```bash
bundle exec rspec
```

## Contributing
Feel free to contribute.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
