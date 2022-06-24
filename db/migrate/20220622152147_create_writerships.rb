class CreateWriterships < ActiveRecord::Migration[7.0]
  def change
    create_table :writerships do |t|
      t.integer :book_id
      t.integer :writer_id

      t.timestamps
    end
  end
end
