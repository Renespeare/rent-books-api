class AddIndexToWriterships < ActiveRecord::Migration[7.0]
  def change
    add_index :writerships, [:book_id, :writer_id], unique: true
  end
end
