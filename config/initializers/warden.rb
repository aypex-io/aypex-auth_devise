# Merges users orders to their account after sign in and sign up.
Warden::Manager.after_set_user except: :fetch do |user, auth, _opts|
  token = auth.cookies.signed[:token]
  token_attr = :token

  if token.present? && user.is_a?(Aypex::Config.user_class)
    Aypex::Order.incomplete.where(token_attr => token, :user_id => nil).each do |order|
      order.associate_user!(user)
    end
  end
end

Warden::Manager.before_logout do |_user, auth, _opts|
  auth.cookies.delete(:token)
end
