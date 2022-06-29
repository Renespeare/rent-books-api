require 'rails_helper'

RSpec.describe Writer, type: :model do
  subject {
    described_class.new(name: "name")
  }


  describe 'Validations' do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it { should validate_presence_of(:name) }
  end

  describe 'Associations' do
    it { should have_many(:writerships) }
    it { should have_many(:books).through(:writerships) }
  end
end
