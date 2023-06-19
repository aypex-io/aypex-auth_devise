require "rubygems"
require "rake"
require "rake/testtask"
require "rspec/core/rake_task"
require "testing_support/common_rake"

RSpec::Core::RakeTask.new

task default: :spec

task :test_app, [:user_class] do |_t, args|
  ENV["LIB_NAME"] = "aypex/auth_devise"

  Aypex::DummyGeneratorHelper.inject_extension_requirements = true
  Rake::Task["common:test_app"].execute(args.with_defaults(install_emails: true, install_checkout: true, install_admin: true, install_storefront: true))
end
