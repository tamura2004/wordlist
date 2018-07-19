class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string :name
      t.string :desc
      t.string :user
      t.boolean :removed, default: false, null:false

      t.timestamps null: false
    end
  end
end
