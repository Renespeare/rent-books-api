class Book < ApplicationRecord
    has_many :writerships
    has_many :writers, through: :writerships
end
