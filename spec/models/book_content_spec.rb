require 'rails_helper'

RSpec.describe BookContent, type: :model do
  describe "Associations" do
    it { should belong_to(:book) }
  end
end
