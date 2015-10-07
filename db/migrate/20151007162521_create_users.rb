class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :uname, unique: true
      t.string :email, unique: true, null: false
      t.string :guid, unique: true, null: false  # global user ID
      t.string :passwd, null: false
      t.boolean :active
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
