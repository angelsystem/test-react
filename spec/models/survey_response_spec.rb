require "rails_helper"

RSpec.describe SurveyResponse, type: :model do

  describe "associations" do
    it {
      is_expected.to belong_to(:submission)
        .class_name("SurveySubmission")
        .inverse_of(:responses)
        .with_foreign_key(:survey_submission_id)
    }

    it {
      is_expected.to belong_to(:question)
        .class_name("SurveyQuestion")
        .inverse_of(:responses)
        .with_foreign_key(:survey_question_id)
    }
  end

end
