require "rails_helper"

describe "survey index", type: :feature do

  context "when signed out" do
    it "is inaccessible" do
      visit("/")
      expect(current_path).to eq("/sign_in")
    end
  end

  context "when signed in" do
    before do
      sign_in
    end

    it "lists all the surveys" do
      survey_title_one = "Louie's new survey"
      survey_title_two = "Brick Button PI"
      create(:survey, title: survey_title_one)
      create(:survey, title: survey_title_two)
      visit("/")
      expect(page).to have_content("2 Surveys")
      expect(page).to have_content(survey_title_one)
      expect(page).to have_content(survey_title_two)
    end

    it "has a link to create a new survey" do
      create_new_survey # Click the link.
      click_on("Surveys") # Go back to the index.
      expect(page).to have_content("1 Survey")
      expect(page).to have_content("Untitled survey")
    end

    it "has links to delete surveys" do
      survey_title = "Louie's New Survey"
      create(:survey, title: survey_title)
      visit("/")
      expect(page).to have_content(survey_title)
      click_link("Delete")
      expect(page).to_not have_content(survey_title)
    end

    it "has links to edit existing surveys" do
      survey = create(:survey)
      visit("/")
      click_on(survey.title)
      expect(current_path).to eq("/surveys/#{survey.id}/edit")
    end
  end

end
