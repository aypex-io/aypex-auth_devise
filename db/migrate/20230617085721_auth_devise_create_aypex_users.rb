class AuthDeviseCreateAypexUsers < ActiveRecord::Migration[7.0]
  # Creates the basic table for use with Aypex
  def change
    create_table Aypex::Config.user_class.table_name, if_not_exists: true do |t|
      t.string :phone
      t.bigint :ship_address_id
      t.bigint :bill_address_id
      t.string :authentication_token
      t.datetime :deleted_at
      if t.respond_to? :jsonb
        t.jsonb :public_metadata
        t.jsonb :private_metadata
      else
        t.json :public_metadata
        t.json :private_metadata
      end
      t.string :first_name
      t.string :last_name
      t.string :selected_locale
      t.bigint :store_id, null: false
      t.index [:bill_address_id], name: "index_#{Aypex::Config.user_class.table_name}_on_bill_address_id"
      t.index [:email, :store_id], name: "index_#{Aypex::Config.user_class.table_name}_on_email_and_store_id"
      t.index [:ship_address_id], name: "index_#{Aypex::Config.user_class.table_name}_on_ship_address_id"

      t.timestamps
    end
  end
end
