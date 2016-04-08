class SurveySubmissionsController < ApplicationController

  # Filters
  before_filter :require_admin, only: [:index]


  # GET /surveys/:survey_id/submissions
  def index
    @survey = Survey.find(params[:survey_id])
    @submissions = @survey.submissions.includes(:responses)
  end

  # GET /surveys/:survey_id
  def new
    @survey = Survey.find(params[:survey_id])
    @submission = SurveySubmission.new
  end

  # POST /surveys/:survey_id/submissions
  def create
    survey = Survey.find(params[:survey_id])
    if survey.submissions.create(submission_params)
      render json: survey, status: 200
    else
      render status: 400
    end
  end

  # GET /surveys/:survey_id/submissions/confirmation
  def confirmation
    @survey = Survey.find(params[:survey_id])
  end


  private

  # Internal: Allowed SurveySubmission params.
  def submission_params
    params.require(:submission).permit(
      responses_attributes: [
        :survey_question_id,
        :answer
      ]
    )
  end

end
