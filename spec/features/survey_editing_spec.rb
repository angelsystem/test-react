require "rails_helper"

describe "survey editing", type: :feature do

  context "when signed out" do
    it "is inaccessible" do
      survey = create(:survey)
      visit edit_survey_path(survey)
      expect(current_path).to eq("/sign_in")
    end
  end

  context "when signed in", js: true do
    before do
      sign_in
      create_new_survey
    end

    it "has a link back to the index" do
      click_on("Surveys")
      expect(current_path).to eq("/")
    end

    it "has a link to sign out" do
      click_on("Sign Out")
      expect(current_path).to eq("/sign_in")
    end

    it "has a link to view responses" do
      survey = Survey.last
      click_on("View Responses")
      expect(current_path).to eq("/surveys/#{survey.id}/submissions")
    end

    it "has a link to view the survey" do
      survey = Survey.last
      click_on("View Survey")
      expect(current_path).to eq("/surveys/#{survey.id}")
    end

    it "has one text question by default" do
      expect(page).to have_css(".Survey_Question_Text", count: 1)
    end

    context "a title" do
      it "can be edited" do
        expect(page).not_to have_css(".SurveyEditor_Attributes-Title h2", text: "New Title")
        find(".SurveyEditor_Attributes-Title-Column").click
        find(".SurveyEditor_Attributes-Title-Column input").set("New Title")
        find(".SurveyEditor_Questions").click
        expect(page).to have_css(".SurveyEditor_Attributes-Title h2", text: "New Title")
      end
    end

    context "a description" do
      it "can be edited" do
        expect(page).not_to have_css(".SurveyEditor_Attributes-Description-Column p", text: "New Description")
        find(".SurveyEditor_Attributes-Description-Column").click
        find(".SurveyEditor_Attributes-Description-Column textarea").set("New Description")
        find(".SurveyEditor_Questions").click
        expect(page).to have_css(".SurveyEditor_Attributes-Description-Column p", text: "New Description")
      end
    end

    context "a multiple choice question" do
      it "can be added and removed" do
        add_multiple_choice_question
        expect(page).to have_css(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice", count: 1)
        click_on("Remove Question")
        find(".Modal button", text: "Remove Question").click
        expect(page).not_to have_css(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice")
      end

      context "after being added" do
        before do
          add_multiple_choice_question
        end

        it "can discard changes" do
          # TODO: Refactor this, excessive use of find to ensure fields are added.
          # Set a title.
          find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Title input").set("What kind of donut do you want?")
          add_multiple_choice_option # At least two options are required.
          click_on("Save")
          # Open again and change the title but discard changes.
          find(".Survey_Question_MultipleChoice")
          all(".Survey_Question").last.click
          find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Title input").set("What kind of cookie do you want?")
          click_on("Discard Changes")
          # Ensure title has not changed.
          find(".Survey_Question_MultipleChoice")
          expect(page).to have_css(".Survey_Question-Title", text: "What kind of donut do you want?")
        end

        context "question title" do
          it "can be edited" do
            find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Title input").set("What kind of donut do you want?")
            add_multiple_choice_option
            click_on("Save")
            expect(page).to have_css(".Survey_Question-Title", text: "What kind of donut do you want?")
          end
        end

        context "help text" do
          it "can be edited" do
            find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Help-Text input").set("Please choose one of the following...")
            add_multiple_choice_option
            click_on("Save")
            expect(page).to have_css(".Survey_Question-Help-Text", text: "Please choose one of the following...")
          end
        end

        context "option" do
          it "can be added and removed" do
            add_multiple_choice_option
            expect(page).to have_css(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice_RadioOption", count: 2)
            all(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice_RadioOption a").last.click
            expect(page).to have_css(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice_RadioOption", count: 1)
          end

          it "can have its text updated" do
            add_multiple_choice_option
            expect(page).to have_css(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice_RadioOption", count: 2)
            all(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice_RadioOption input[type=text]").last.set("Jelly")
            click_on("Save")
            expect(page).to have_css(".Survey_Question_MultipleChoice_RadioOption span", text: "Jelly")
          end

          it "can be added as an 'Other:' option" do
            find(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice-Add-Option a").click
            click_on("Save")
            expect(page).to have_css(".Survey_Question", count: 2)
            expect(all(".Survey_Question").last).to have_content("Other:")
          end
        end
      end
    end

    context "a text question" do
      it "can be added and removed" do
        add_text_question
        expect(page).to have_css(".SurveyEditor_Questions_QuestionList_Question_Text", count: 1)
        click_on("Remove Question")
        find(".Modal button", text: "Remove Question").click
        expect(page).not_to have_css(".SurveyEditor_Questions_QuestionList_Question_Text")
      end

      context "after being added" do
        before do
          # No need to add one since there is a text question by default.
          find(".Survey_Question").click
        end

        it "can discard changes" do
          # Set a title
          find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Title input").set("What kind of donut do you want?")
          click_on("Save")
          # Open again and change the title but discard changes.
          all(".Survey_Question").last.click
          find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Title input").set("What kind of cookie do you want?")
          click_on("Discard Changes")
          # Ensure title has not changed.
          expect(page).to have_css(".Survey_Question-Title", text: "What kind of donut do you want?")
        end

        context "question title" do
          it "can be edited" do
            find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Title input").set("What kind of donut do you want?")
            click_on("Save")
            expect(page).to have_css(".Survey_Question-Title", text: "What kind of donut do you want?")
          end
        end

        context "help text" do
          it "can be edited" do
            find(".SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Help-Text input").set("Please choose one of the following...")
            click_on("Save")
            expect(page).to have_css(".Survey_Question-Help-Text", text: "Please choose one of the following...")
          end
        end
      end
    end
  end

end
