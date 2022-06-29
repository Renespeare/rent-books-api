require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(username: "user",
                        email: "user@gmail.com",
                        password: 'password',
                        password_confirmation: 'password',
                        phone_number: nil,
                        address: nil,
                        is_admin: false)
  }

  describe 'Validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a email" do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a username" do
      subject.username = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with different password confirmation" do
      subject.password_confirmation = 'pass'
      expect(subject).to_not be_valid
    end

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password) }
    it {
      should validate_length_of(:password)
        .is_at_least(8)
    }
  end

  describe 'Associations' do
    it { should have_many(:borrows) }
    it { should have_many(:books).through(:borrows) }
  end
end
