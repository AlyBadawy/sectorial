class CreateSecurialRoles < ActiveRecord::Migration[8.0]
  def change
    create_table :securial_roles do |t|
      t.string :role_name
      t.boolean :hide_from_profile, default: false, null: false

      t.timestamps
    end

    add_index :securial_roles, :role_name, unique: true
  end
end
