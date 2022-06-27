class AddIndexToBorrows < ActiveRecord::Migration[7.0]
  def change
    add_index :borrows, [:book_id, :user_id], unique: true
  end
end
