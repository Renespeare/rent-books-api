class Writer < ApplicationRecord
    has_many :writerships
    has_many :books, -> { distinct }, through: :writerships
    validates :name, presence: :true
end
