RSpec.configure do |config|
  config.around do |example|
    if example.metadata.key?(:confirmable)
      old_user = Aypex::User

      begin
        example.run
      ensure
        Aypex.const_set(:User, old_user)
      end
    else
      example.run
    end
  end

  config.before do |example|
    if example.metadata.key?(:confirmable)
      Rails.cache.clear
      Aypex::AuthDevise::Config.confirmable = example.metadata[:confirmable]

      Aypex.send(:remove_const, :User)
      load File.expand_path("../../app/models/aypex/user.rb", __dir__)
    end
  end

  config.after do |example|
    if example.metadata.key?(:confirmable)
      Rails.cache.clear
      Aypex::AuthDevise::Config.confirmable = false

      Aypex.send(:remove_const, :User)
      load File.expand_path("../../app/models/aypex/user.rb", __dir__)
    end
  end
end
