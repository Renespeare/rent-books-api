require 'rails_helper'

RSpec.describe Writership, type: :model do
  describe "Associations" do
    it { should belong_to(:book) }
    it { should belong_to(:writer) }
  end
end
