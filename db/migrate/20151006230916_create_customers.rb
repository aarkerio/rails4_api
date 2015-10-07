class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.string :api_key, unique: true
      t.string :secret_key
      t.boolean :active

      t.timestamps null: false
    end
  end
end
