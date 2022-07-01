class AddIndexToReviews < ActiveRecord::Migration[7.0]
  def change
    add_index :reviews, [:book_id, :user_id], unique: true
  end
end
