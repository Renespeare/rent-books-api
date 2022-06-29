require 'rails_helper'

RSpec.describe Borrow, type: :model do
  let(:user) { FactoryBot.create(:user, username: 'user', email: 'user@gmail.com', password: 'password', password_confirmation: 'password') }

  let(:book){ FactoryBot.create(:book, title: "title", synopsis: 'synopsis',
    genre: 'genre', publisher: 'publisher', published_year: '1990', page_count: 201, isbn: '1234') }

  let(:borrow){ Borrow.new(
    book_id: book.id,
    user_id: user.id,
    date_rent: DateTime.now,
    date_return: DateTime.now + 2.months,
    is_return: false) }

  describe 'Validations' do
    it "is valid with valid attributes" do
      expect(borrow).to be_valid
    end
  end

  describe "Associations" do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end
end
