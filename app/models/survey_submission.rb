# Public: The survey submission object is the parent of a collection of responses
# that represent a response to a survey's questions.
#
# Examples:
#
#   survey = Survey.create
#   # => #<Survey id: 1, title: "Untitled", description: null, ...>
#   survey.questions.create(title: "What's your name?", ...)
#   # => #<SurveySubmission id: 1, survey_id: 2, ...>
#   survey.submissions.create(responses_attributes: {0: {survey_question_id: 1, ...}})
class SurveySubmission < ActiveRecord::Base

  # Associations
  belongs_to :survey, inverse_of: :submissions
  has_many :responses, class_name: "SurveyResponse", inverse_of: :submission, dependent: :destroy


  # Nested Attributes
  accepts_nested_attributes_for :responses

end
