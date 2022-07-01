class Book < ApplicationRecord
    has_many :writerships
    has_many :reviews, -> { distinct }, through: :user
    has_many :writers, -> { distinct }, through: :writerships
    has_many :borrows
    has_many :users, -> { distinct }, through: :borrows
end
