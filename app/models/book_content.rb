class BookContent < ApplicationRecord
    include PdfUploader::Attachment(:pdf)
    belongs_to :book
    validates :book_id, presence: true, uniqueness: true
    validates :pdf_data, presence: true
end
