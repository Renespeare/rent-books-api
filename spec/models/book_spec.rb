require 'rails_helper'
include ActionDispatch::TestProcess::FixtureFile

RSpec.describe Book, type: :model do

  # there is a problem in fixture, can't detect mime types

  # let(:image) { fixture_file_upload('image.png') }
  # subject {
  #   described_class.new(title: 'title',
  #                       synopsis: 'synopsis',
  #                       genre: 'genre',
  #                       publisher: 'publisher',
  #                       published_year: '1990',
  #                       page_count: 201,
  #                       isbn: '1234',
  #                       image: image
  #                     )
  # }

  # describe 'Validations' do
  #   it "is valid with valid attributes" do
  #     expect(subject).to be_valid
  #   end
  # end

  describe 'Associations' do
    it { should have_many(:writerships) }
    it { should have_many(:writers).through(:writerships) }
    it { should have_many(:borrows) }
    it { should have_many(:users).through(:borrows) }
  end
end
