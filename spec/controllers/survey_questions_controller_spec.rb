require "rails_helper"

RSpec.describe SurveyQuestionsController, type: :controller do

  # Filters
  it { is_expected.to use_before_action(:find_survey) }
  it { is_expected.to use_before_action(:require_admin) }

  let(:survey) { create(:survey) }
  let(:survey_question) { create(:survey_question, survey: survey) }


  describe "create" do
    context "when logged out" do
      before do
        post :create, survey_id: survey.id
      end

      it { is_expected.to respond_with 302 }
    end

    context "when logged in" do
      before do
        session[:admin_id] = create(:admin).id
      end

      it do
        allow_any_instance_of(Survey).to receive_message_chain(:questions, :create) { survey_question }
        is_expected.to permit(
          :title,
          :help_text,
          :question_type,
          :position,
          data: [
            { options: [] },
            :otherToggled
          ]
        ).for(:create, params: { survey_id: survey.id, format: :json })
      end

      it "should create a new question" do
        expect {
          post :create, survey_id: survey.id, question: attributes_for(:survey_question), format: :json
        }.to change(SurveyQuestion, :count).by(1)
      end

      it "should respond with the json represenation of the new question with formAction appended" do
        post :create, survey_id: survey.id, question: attributes_for(:survey_question), format: :json
        new_question = SurveyQuestion.last
        new_question_json = new_question.as_json
        new_question_json['formAction'] = survey_question_path(survey, new_question)
        expect(response.body).to eq(new_question_json.to_json)
      end
    end
  end

  describe "update" do
    context "when logged out" do
      before do
        patch :update, survey_id: survey.id, id: survey_question.id, format: :json
      end

      it { is_expected.to respond_with 302 }
    end

    context "when logged in" do
      before do
        session[:admin_id] = create(:admin).id
      end

      it do
        is_expected.to permit(
          :title,
          :help_text,
          :question_type,
          :position,
          data: [
            { options: [] },
            :otherToggled
          ]
        ).for(:update, params: { survey_id: survey.id, id: survey_question.id, format: :json })
      end

      it "should update the question" do
        expect {
          patch :update, survey_id: survey.id, id: survey_question.id, question: { title: "New Title" }, format: :json
        }.to change { survey_question.reload.title }.to("New Title")
      end

      it "should respond with the json of the updated question" do
        patch :update, survey_id: survey.id, id: survey_question.id, question: { title: "New Title" }, format: :json
        expect(response.body).to eq(survey_question.reload.to_json)
      end
    end
  end


  describe "destroy" do
    context "when logged out" do
      before do
        delete :destroy, survey_id: survey.id, id: survey_question.id, format: :json
      end

      it { is_expected.to respond_with 302 }
    end

    context "when logged in" do
      before do
        session[:admin_id] = create(:admin).id

        @survey = create(:survey)
        @survey_question = create(:survey_question, survey: @survey)
      end

      it "should destroy the question" do
        expect {
          delete :destroy, survey_id: @survey.id, id: @survey_question.id, format: :json
        }.to change { @survey.reload.questions.count }.by(-1)
      end

      it "should respond with the json of the deleted question" do
        delete :destroy, survey_id: @survey.id, id: @survey_question.id, format: :json
        expect(response.body).to eq(@survey_question.to_json)
      end
    end
  end

end
