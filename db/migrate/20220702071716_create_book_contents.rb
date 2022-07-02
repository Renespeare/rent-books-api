class CreateBookContents < ActiveRecord::Migration[7.0]
  def change
    create_table :book_contents do |t|
      t.integer :book_id

      t.timestamps
    end
  end
end
