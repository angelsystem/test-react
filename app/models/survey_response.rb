# Public: Survey responses are the children of a survey submission that make up
# the submission's responses to the survey's questions. Note: a SurveyResponse
# should NOT be created directly, instead a SurveySubmission should be created
# with the responses created via nested attributes.
#
# Examples:
#
#   survey = Survey.create
#   # => #<Survey id: 1, title: "Untitled", description: null, ...>
#   survey.questions.create(title: "What's your name?", ...)
#   # => #<SurveyQuestion id: 1, survey_id: 1, ...>
#   survey.submissions.create(responses_attributes: {0: {survey_question_id: 1, ...}})
class SurveyResponse < ActiveRecord::Base

  # Associations
  belongs_to :submission, class_name: "SurveySubmission", inverse_of: :responses, foreign_key: :survey_submission_id
  belongs_to :question, class_name: "SurveyQuestion", inverse_of: :responses, foreign_key: :survey_question_id


  # Scopes
  scope :order_by_question_position, -> { includes(:question).order("survey_questions.position ASC") }

end
