class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :number
      t.string :name
      t.string :hashed_password
      t.integer :year
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
