class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string  :name
      t.string  :api_key, unique: true, null: false
      t.string  :secret_key
      t.boolean :active
      t.string  :db_name
      t.string  :db_user
      t.string  :db_pwd
      t.string  :db_staging
      t.string  :db_production
      t.timestamps null: false
    end
  end
end
