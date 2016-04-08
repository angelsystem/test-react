require "rails_helper"

RSpec.describe AdminSession, type: :model do

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe ".initialize" do
    pending
  end

  describe "#authenticate!" do
    pending
  end

  describe "#admin" do
    pending
  end

end
