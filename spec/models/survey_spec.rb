require "rails_helper"

RSpec.describe Survey, type: :model do

  describe "associations" do
    it { is_expected.to have_many(:questions).class_name("SurveyQuestion").inverse_of(:survey).dependent(:destroy) }
    it { is_expected.to have_many(:submissions).class_name("SurveySubmission").inverse_of(:survey).dependent(:destroy) }
  end

  # These don't work because of the set_default_title and generate_slug callbacks
  # describe "validations" do
  #   it { should validate_presence_of(:title) }
  #   it { should validate_presence_of(:slug) }
  #   it { should validate_uniqueness_of(:slug) }
  # end

  describe "callbacks" do
    let(:survey) { build(:survey) }

    context "before_validation" do
      context "on create" do
        it "should call set_default_title on create" do
          expect(survey).to receive(:set_default_title)
          survey.save
        end

        it "should call generate_slug" do
          expect(survey).to receive(:generate_slug)
          survey.save
        end
      end

      context "on update" do
        before do
          survey.save
        end

        it "should not call set_default_title on create" do
          expect(survey).to_not receive(:set_default_title)
          survey.save
        end

        it "should not call generate_slug" do
          expect(survey).to_not receive(:generate_slug)
          survey.save
        end
      end
    end
  end

  describe "instance methods" do
    describe "question_order=" do
      let(:survey) { create(:survey) }

      before do
        create_list(:survey_question, 5, survey: survey)
      end

      it "should update the question order using the provided array of ids" do
        original_order = survey.questions.order_by_position.map{ |q| q.id.to_s }
        new_order = original_order.reverse
        expect {
          survey.question_order = new_order
        }.to change { survey.reload.questions.order_by_position.map{ |q| q.id.to_s } }.from(original_order).to(new_order)
      end
    end

    describe "set_default_title" do
      context "title is blank" do
        it "should set the title to 'Untitled survey'" do
          survey = build(:survey, title: nil)
          expect {
            survey.send(:set_default_title)
          }.to change(survey, :title).from(nil).to("Untitled survey")
        end
      end

      context "title is not blank" do
        it "should not change the title" do
          survey = build(:survey, title: "Title")
          expect {
            survey.send(:set_default_title)
          }.to_not change(survey, :title)
        end
      end
    end

    describe "generate_slug" do
      it "should change the slug" do
        survey = build(:survey)
        expect {
          survey.send(:generate_slug)
        }.to change(survey, :slug)
      end
    end
  end

end
