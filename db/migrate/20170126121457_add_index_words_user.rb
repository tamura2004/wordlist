class AddIndexWordsUser < ActiveRecord::Migration
  def change
    add_index :words,"user"
  end
end
