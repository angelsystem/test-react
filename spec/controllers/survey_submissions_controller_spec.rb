require "rails_helper"

RSpec.describe SurveySubmissionsController, type: :controller do

  let(:survey) { create(:survey) }

  describe "index" do
    context "when logged out" do
      before do
        get :index, survey_id: survey.id
      end

      it { is_expected.to respond_with 302 }
    end

    context "when logged in" do
      before do
        session[:admin_id] = create(:admin).id
      end

      let(:submission) { create(:survey_submission, survey: survey) }

      it "should assign survey" do
        get :index, survey_id: survey.id
        expect(assigns(:survey)).to eq(survey)
      end

      it "should assign @submissions" do
        get :index, survey_id: survey.id
        expect(assigns(:submissions)).to eq([submission])
      end

      it "should respond with a 200" do
        get :index, survey_id: survey.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end
  end


  describe "new" do
    it "should assign survey" do
      get :new, survey_id: survey.id
      expect(assigns(:survey)).to eq(survey)
    end

    it "should assign @submissions" do
      get :new, survey_id: survey.id
      expect(assigns(:submissions))
    end

    it "should render the new template" do
      get :new, survey_id: survey.id
      expect(response).to render_template("new")
    end
  end


  describe "create" do
    let(:submission_attributes) { attributes_for(:survey_submission, responses: [attributes_for(:survey_response)]) }

    it do
      is_expected.to permit(
        responses_attributes: [
          :survey_question_id,
          :answer
        ]
      ).for(:create, params: { survey_id: survey.id })
    end

    context "when successful" do
      context "when the admin is logged in" do
        let(:admin) { create(:admin) }

        before do
          session[:admin_id] = admin.id
        end

        xit "the admin's submissions count increments" do
          expect {
            post :create,
              survey_id: survey.id,
              submission: submission_attributes
          }.to change{ admin.submissions.count }.by(1)
        end
      end

      context "when the admin isn't logged in" do
        let(:admin) { create(:admin) }

        before do
          session[:admin_id] = nil
        end

        xit "doesn't allow someone to impersonate them" do
          expect{
            post :create,
              survey_id: survey.id,
              submission: submission_attributes,
              admin_id: admin.id
          }.to change(SurveySubmission, :count).by(1)
          expect(SurveySubmission.last.admin_id).to equal(nil)
        end
      end

      it "should create a new survey" do
        expect {
          post :create, survey_id: survey.id, submission: submission_attributes
        }.to change(SurveySubmission, :count).by(1)
      end

      it "should respond with the survey's JSON" do
        post :create, survey_id: survey.id, submission: submission_attributes
        expect(response.body).to eq(survey.to_json)
      end
    end

    context "with invalid params" do
      before do
        get :index, survey_id: survey.id
      end

      it { is_expected.to respond_with 302 }
    end
  end


  describe "confirmation" do
    it "should assign survey" do
      get :confirmation, survey_id: survey.id
      expect(assigns(:survey)).to eq(survey)
    end

    it "should respond with a 200" do
      get :confirmation, survey_id: survey.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

end
