class Writer < ApplicationRecord
    has_many :writerships
    has_many :books, through: :writerships
end
