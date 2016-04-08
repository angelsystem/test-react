class SurveyQuestionsController < ApplicationController

  # Filters
  before_filter :require_admin
  before_filter :find_survey


  # POST /surveys/:survey_id/questions
  def create
    question = @survey.questions.create(question_params)

    json = question.as_json
    json["formAction"] = survey_question_path(@survey, question)

    respond_to do |format|
      format.json { render json: json }
    end
  end

  # PATCH /surveys/:survey_id/questions/:id
  def update
    question = @survey.questions.find(params[:id])

    question.update(question_params)

    respond_to do |format|
      format.json { render json: question }
    end
  end

  # DELETE /surveys/:survey_id/questions/:id
  def destroy
    question = @survey.questions.find(params[:id])

    question.destroy

    respond_to do |format|
      format.json { render json: question }
    end
  end


  private

  # Internal: Find the survey reference.
  def find_survey
    @survey = Survey.find(params[:survey_id])
  end

  # Internal: Allowed SurveyQuestion params.
  def question_params
    params.require(:question).permit(
      :title,
      :help_text,
      :question_type,
      :position,
      data: [
        { options: [] },
        :otherToggled
      ]
    )
  end

end
