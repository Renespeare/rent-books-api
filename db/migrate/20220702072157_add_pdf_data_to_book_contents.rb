class AddPdfDataToBookContents < ActiveRecord::Migration[7.0]
  def change
    add_column :book_contents, :pdf_data, :jsonb
  end
end
