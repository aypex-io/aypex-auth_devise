source "https://rubygems.org"

gem "aypex", github: "aypex-io/aypex"
gem "aypex-api", github: "aypex-io/aypex-api"
gem "aypex-admin", github: "aypex-io/aypex-admin"
gem "aypex-emails", github: "aypex-io/aypex-emails"
gem "aypex-storefront", github: "aypex-io/aypex-storefront"
gem "devise", github: "heartcombo/devise"

if ENV["DB"] == "mysql"
  gem "mysql2"
else
  gem "pg"
end

group :test do
  gem "propshaft"
end

group :test, :development do
  gem "aypex_dev_tools", github: "aypex-io/aypex_dev_tools"
  gem "debug"
end

gemspec
