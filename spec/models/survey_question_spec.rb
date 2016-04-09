require "rails_helper"

RSpec.describe SurveyQuestion, type: :model do

  describe "attributes" do
    it { is_expected.to serialize(:data) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:survey).inverse_of(:questions) }
    it { is_expected.to have_many(:responses).class_name("SurveyResponse").inverse_of(:question).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:question_type).in_array(["Multiple Choice", "Text"]) }
    it { is_expected.to validate_presence_of(:question_type) }
  end

  describe "scopes" do
    describe "order_by_position" do
      let(:last)   { create(:survey_question, position: 3) }
      let(:first)  { create(:survey_question, position: 1) }
      let(:second) { create(:survey_question, position: 2) }

      it "should return the SurveyQuestions ordered by position" do
        expect(SurveyQuestion.order_by_position.all).to match([first, second, last])
      end
    end
  end

  describe "callbacks" do
    describe "before_validation" do
      it "calls set_title_to_blank_if_nil" do
        survey_question = build(:survey_question)
        expect(survey_question).to receive(:set_title_to_blank_if_nil)
        survey_question.save
      end
    end
  end

  describe "instance methods" do
    describe "#set_title_to_blank_if_nil" do
      it "sets the title an empty string if the title is nil" do
        survey_question = build(:survey_question, title: nil)
        expect {
          survey_question.set_title_to_blank_if_nil
        }.to change{ survey_question.title }.from(nil).to("")
      end
    end
  end

end
