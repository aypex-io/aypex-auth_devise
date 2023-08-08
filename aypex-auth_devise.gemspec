require_relative "lib/aypex/auth_devise/version"

Gem::Specification.new do |spec|
  spec.name = "aypex-auth_devise"
  spec.version = Aypex::AuthDevise::VERSION
  spec.authors = ["Matthew Kennedy"]
  spec.email = ["m.kennedy@me.com"]
  spec.homepage = "https://aypex.io"
  spec.summary = "Provides authentication and authorization services for use with Aypex by using Devise and CanCan."
  spec.description = spec.summary
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["bug_tracker_uri"] = "https://github.com/aypex-io/aypex-auth_devise/issues"
  spec.metadata["changelog_uri"] = "https://github.com/aypex-io/aypex-auth_devise/releases/tag/v#{spec.version}"
  spec.metadata["source_code_uri"] = "https://github.com/aypex-io/aypex-auth_devise/tree/v#{spec.version}"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "aypex"
  spec.add_dependency "devise", "~> 4.9.0"
  spec.add_dependency "inline_svg"
  spec.add_dependency "responders"
  spec.add_dependency "turbo-rails"
end
