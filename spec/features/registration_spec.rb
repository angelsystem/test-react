require "rails_helper"

describe "registration", type: :feature do

  context "register" do
    it "has a sign in link" do
      visit("/register")
      click_on("Sign In")
      expect(current_path).to eq("/sign_in")
    end

    it "redirects you to the surveys index" do
      visit("/register")
      fill_in("admin_registration_email", with: "louie@able.co")
      fill_in("admin_registration_password", with: "password")
      fill_in("admin_registration_password_confirmation", with: "password")
      click_on("Sign Up")
      expect(current_path).to eq("/")
    end

    context "email address" do
      context "exists" do
        it "fails" do
          existing_admin = create(:admin)
          visit("/register")
          fill_in("admin_registration_email", with: existing_admin.email)
          fill_in("admin_registration_password", with: "password")
          fill_in("admin_registration_password_confirmation", with: "password")
          click_on("Sign Up")
          expect(page).to have_content("Email has already been taken")
        end
      end

      context "invalid format" do
        it "fails" do
          visit("/register")
          fill_in("admin_registration_email", with: "bad@format")
          fill_in("admin_registration_password", with: "password")
          fill_in("admin_registration_password_confirmation", with: "password")
          click_on("Sign Up")
          expect(page).to have_content("Email is invalid")
        end
      end
    end

    context "password" do
      context "is missing" do
        it "fails" do
          visit("/register")
          fill_in("admin_registration_email", with: "louie@brickbutton.org")
          fill_in("admin_registration_password", with: "")
          fill_in("admin_registration_password_confirmation", with: "")
          click_on("Sign Up")
          expect(page).to have_content("Password can't be blank")
        end
      end

      context "confirmation is missing" do
        it "fails" do
          visit("/register")
          fill_in("admin_registration_email", with: "louie@brickbutton.org")
          fill_in("admin_registration_password", with: "password")
          fill_in("admin_registration_password_confirmation", with: "")
          click_on("Sign Up")
          expect(page).to have_content("Password Confirmation doesn't match Password")
        end
      end

      context "confirmation does not match" do
        it "fails" do
          visit("/register")
          fill_in("admin_registration_email", with: "louie@brickbutton.org")
          fill_in("admin_registration_password", with: "password")
          fill_in("admin_registration_password_confirmation", with: "wrong password")
          click_on("Sign Up")
          expect(page).to have_content("Password Confirmation doesn't match Password")
        end
      end
    end
  end

  context "sign in" do
    it "has a sign up link" do
      visit("/sign_in")
      click_on("Sign Up")
      expect(current_path).to eq("/register")
    end

    it "redirects you to the surveys index" do
      sign_in
      expect(current_path).to eq("/")
      expect(page).to have_content("0 Surveys")
    end

    context "email address" do
      context "is incorrect" do
        it "fails" do
          fill_out_and_submit_sign_in("wrong@able.co", "whatever")
          expect(current_path).to eq("/sign_in")
          expect(page).to have_content("Email is invalid")
        end
      end

      context "is missing" do
        it "fails" do
          fill_out_and_submit_sign_in("", "whatever")
          expect(current_path).to eq("/sign_in")
          expect(page).to have_content("Email can't be blank")
        end
      end
    end

    context "password" do
      context "is incorrect" do
        it "fails" do
          fill_out_and_submit_sign_in(create(:admin).email, "wrong password")
          expect(current_path).to eq("/sign_in")
          expect(page).to have_content("Password is invalid")
        end
      end

      context "is missing" do
        it "fails" do
          visit("/sign_in")
          fill_in("admin_session_email", with: create(:admin).email)
          click_on("Sign In")
          expect(current_path).to eq("/sign_in")
          expect(page).to have_content("Password can't be blank")
        end
      end
    end
  end

end
