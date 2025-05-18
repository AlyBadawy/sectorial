class CreateSecurialUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :securial_users, id: :string do |t|
      t.string :email_address
      t.string :password_digest
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :username
      t.string :bio

      t.timestamps
    end

    add_index :securial_users, :email_address, unique: true
    add_index :securial_users, :username, unique: true
  end
end
