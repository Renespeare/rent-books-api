class Book < ApplicationRecord
    include ImageUploader::Attachment(:image)
    has_many :writerships
    has_many :reviews, -> { distinct }, through: :user
    has_many :writers, -> { distinct }, through: :writerships
    has_many :borrows
    has_many :users, -> { distinct }, through: :borrows
    has_one :book_content, -> { distinct }
    # validates :image_data, presence: true
end
