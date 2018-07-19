class AddIndexWordsUser < ActiveRecord::Migration[5.0]
  def change
    add_index :words,"user"
  end
end
