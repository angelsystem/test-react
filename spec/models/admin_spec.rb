require "rails_helper"

RSpec.describe Admin, type: :model do

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_presence_of(:password_digest) }
  end


  describe "instance methods" do

    describe "password=" do
      let(:password) { "louie" }
      let(:password_digest) { BCrypt::Password.create(password) }
      let(:existing_admin) { create(:admin, password: password) }

      it "should assign password_digest with its encrypted value" do
        admin = Admin.new(password: password)
        unencrypted_password_digest = BCrypt::Password.new(admin.password_digest)
        expect(unencrypted_password_digest).to eq(password)
      end

      it "should not assign a value to the password_digest if it's blank" do
        expect {
          existing_admin.password = ""
        }.to_not change(existing_admin, :password_digest)
      end

      it "should set password_digest to nil if it's nil" do
        expect {
          existing_admin.password = nil
        }.to change(existing_admin, :password_digest).to(nil)
      end
    end

  end

end
