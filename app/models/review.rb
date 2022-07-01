class Review < ApplicationRecord
    belongs_to :book
    belongs_to :user
    validates :star, numericality: { less_than_or_equal_to: 5,  only_integer: true }
end
