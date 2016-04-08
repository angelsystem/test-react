require "rails_helper"

RSpec.describe AdminRegistration, type: :model do

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_confirmation_of(:password) }
  end

  describe ".initialize" do
    pending
  end

  describe "#create!" do
    pending
  end

end
