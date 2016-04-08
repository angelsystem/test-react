class SurveysController < ApplicationController

  # Filters
  before_filter :require_admin


  # GET /
  def index
    @surveys = Survey.all
  end

  # POST /surveys
  def create
    survey = Survey.create
    survey.questions.create(question_type: SurveyQuestion::TYPES.last, position: 0)

    redirect_to(edit_survey_path(survey))
  end

  # GET /surveys/:id/edit
  def edit
    @survey = Survey.find(params[:id])
  end

  # PATCH /surveys/:id
  def update
    survey = Survey.find(params[:id])

    survey.update(survey_params)

    respond_to do |format|
      format.json { render json: survey }
      format.html { redirect_to(edit_survey_path(survey)) }
    end
  end

  def destroy
    survey = Survey.find(params[:id])
    survey.destroy
    redirect_to root_path
  end


  private

  # Internal: Allowed Survey params.
  def survey_params
    params.require(:survey).permit(
      :title,
      :description,
      :data,
      question_order: []
    )
  end

end
