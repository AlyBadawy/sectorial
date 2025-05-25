class AddPasswordResetFieldsToSecurialUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :securial_users, :reset_password_token, :string
    add_column :securial_users, :reset_password_token_created_at, :datetime
  end
end
