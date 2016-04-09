require "rails_helper"

RSpec.describe SurveysController, type: :controller do

  let(:survey) { create(:survey) }

  describe "index" do
    context "when logged out" do
      before do
        get :index
      end

      it { is_expected.to respond_with 302 }
    end

    context "when logged in" do
      before do
        session[:admin_id] = create(:admin).id
      end

      it "should assign @surveys" do
        survey_one = create(:survey)
        survey_two = create(:survey)
        get :index
        expect(assigns(:surveys)).to eq([survey_one, survey_two])
      end

      it "should respond with a 200" do
        get :index
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end
  end


  describe "create" do
    context "when logged out" do
      before do
        post :create
      end

      it { is_expected.to respond_with 302 }
    end

    context "when logged in" do
      before do
        session[:admin_id] = create(:admin).id
      end

      it "should create a new survey" do
        expect {
          post :create
        }.to change(Survey, :count).by(1)
      end

      it "should redirect to edit survey" do
        post :create
        survey = Survey.last
        expect(response).to redirect_to(edit_survey_path(survey))
      end
    end
  end


  describe "edit" do
    context "when logged out" do
      before do
        get :edit, id: survey.id
      end

      it { is_expected.to respond_with 302 }
    end

    context "when logged in" do
      before do
        session[:admin_id] = create(:admin).id
      end

      it "should assign @survey" do
        get :edit, id: survey.id
        expect(assigns(:survey)).to eq(survey)
      end

      it "should respond with a 200" do
        get :edit, id: survey.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end
  end


  describe "update" do
    context "when logged out" do
      before do
        patch :update, id: survey.id
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
          :description,
          :data,
          question_order: []
        ).for(:update, params: { id: survey.id })
      end

      it "should update the survey" do
        expect {
          expect {
            patch :update, id: survey.id, survey: { title: "New Title", description: "New description" }
          }.to change { survey.reload.title }.to("New Title")
        }.to change { survey.reload.description }.to("New description")
      end

      context "html" do
        it "should redirect to edit survey" do
          patch :update, id: survey.id, survey: { title: "New Title" }
          expect(response).to redirect_to(edit_survey_path(survey))
        end
      end

      context "json" do
        it "should respond with the json representation of the survey" do
          patch :update, id: survey.id, survey: { title: "New Title" }, format: :json
          expect(response.body).to eq(survey.reload.to_json)
        end
      end
    end
  end

end
