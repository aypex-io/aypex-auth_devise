RSpec.configure do |config|
  config.after do
    Aypex::Ability.abilities.delete(AbilityDecorator) if Aypex::Ability.abilities.include?(AbilityDecorator)
  end
end

if defined? CanCan::Ability
  class AbilityDecorator
    include CanCan::Ability

    def initialize(_user)
      cannot :manage, Aypex::Order
    end
  end
end
