class User < ApplicationRecord
    has_secure_password
    has_many :borrows
    has_many :reviews
    has_many :books, -> { distinct }, through: :borrows
    validates :email, presence: true, uniqueness: true
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :username, presence: true, uniqueness: true
    validates :password,  confirmation: true,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }
    validates :password_confirmation, presence: true,
            if: -> { new_record? || !password.nil? } 
end
