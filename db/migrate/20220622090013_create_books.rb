class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :synopsis
      t.string :genre
      t.string :publisher
      t.string :published_year
      t.integer :page_count
      t.string :isbn

      t.timestamps
    end
  end
end
