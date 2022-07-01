class AddImageDataToBooks < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :image_data, :jsonb
  end
end
