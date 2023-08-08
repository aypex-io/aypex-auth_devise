class AddAuthDeviseColumnsToAypexUsers < ActiveRecord::Migration[7.0]
  # Add Devise Columns
  def change
    if Aypex::Config.user_class.present?
      ## Database authenticatable
      add_column Aypex::Config.user_class.table_name, :email, :string, null: false, default: "", if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :encrypted_password, :string, null: false, default: "", if_not_exists: true

      ## Recoverable
      add_column Aypex::Config.user_class.table_name, :reset_password_token, :string, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :reset_password_sent_at, :datetime, if_not_exists: true

      ## Rememberable
      add_column Aypex::Config.user_class.table_name, :remember_created_at, :datetime, if_not_exists: true

      ## Trackable
      add_column Aypex::Config.user_class.table_name, :sign_in_count, :integer, default: 0, null: false, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :current_sign_in_at, :datetime, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :last_sign_in_at, :datetime, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :current_sign_in_ip, :string, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :last_sign_in_ip, :string, if_not_exists: true

      ## Confirmable
      add_column Aypex::Config.user_class.table_name, :confirmation_token, :string, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :confirmed_at, :datetime, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :confirmation_sent_at, :datetime, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :unconfirmed_email, :string, if_not_exists: true

      ## Lockable
      add_column Aypex::Config.user_class.table_name, :failed_attempts, :integer, default: 0, null: false, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :unlock_token, :string, if_not_exists: true
      add_column Aypex::Config.user_class.table_name, :locked_at, :datetime, if_not_exists: true
    end

    add_index Aypex::Config.user_class.table_name, :reset_password_token, unique: true, if_not_exists: true
    add_index Aypex::Config.user_class.table_name, :confirmation_token, unique: true, if_not_exists: true
    add_index Aypex::Config.user_class.table_name, :unlock_token, unique: true, if_not_exists: true
  end
end
