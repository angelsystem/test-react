require "rails_helper"

describe "a survey", type: :feature do
  let(:survey) { create(:survey, questions: [build(:survey_question)]) }

  context "when signed out" do
    it "does not have the admin menu" do
      visit("/surveys/#{survey.id}")
      expect(page).to_not have_content("Edit Survey")
      expect(page).to_not have_content("View Survey")
      expect(page).to_not have_content("View Responses")
    end
  end

  ["signed in", "signed out"].each do |sign_in_status|
    context "when #{sign_in_status} out" do
      before do
        sign_in if sign_in_status == "signed in"
        visit("/surveys/#{survey.id}")
      end

      it "allows submitting", js: true do
        find(".Survey_Question")
        find(".Survey_Question input[type=text]").set("Survey response")
        page.execute_script("React.addons.TestUtils.Simulate.submit(document.getElementsByTagName('form')[0])")
        # Wait for the confirmation to load, otherwise the after hook is called
        # and the survey gets deleted: https://github.com/jnicklas/capybara/issues/1089.
        find(".confirmation")
        expect(current_path).to eq("/surveys/#{survey.id}/confirmation")
        expect(page).to have_content("Thank you!")
      end
    end
  end

end