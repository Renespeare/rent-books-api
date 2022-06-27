class CreateBorrows < ActiveRecord::Migration[7.0]
  def change
    create_table :borrows do |t|
      t.integer :book_id
      t.integer :user_id
      t.datetime :date_rent
      t.datetime :date_return

      t.timestamps
    end
  end
end
