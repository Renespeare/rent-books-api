class Review < ApplicationRecord
    belongs_to :book
    belongs_to :user
    validates :star, length: {maximum: 5}
end
