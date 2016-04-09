# Public: Survey questions are the children of a survey.
# When a SurveyResponse is created, it references a specific
# question.
#
# Examples:
#
#   survey = Survey.create
#   # => #<Survey id: 1, title: "Untitled", description: null, ...>
#   survey.questions.create(title: "What's your name?", ...)
#   # => #<SurveyQuestion id: 1, survey_id: 1, ...>
class SurveyQuestion < ActiveRecord::Base

  TYPES = ["Multiple Choice", "Text"]

  # Attributes
  serialize :data, Hash


  # Associations
  belongs_to :survey, inverse_of: :questions
  has_many :responses, class_name: "SurveyResponse", inverse_of: :question, dependent: :destroy


  # Validations
  validates :question_type, presence: true, inclusion: { in: TYPES }
  validates :title, length: { in: 0..255 }, allow_nil: false


  # Scopes
  scope :order_by_position, -> { order(:position) }


  # Callbacks
  before_validation :set_title_to_blank_if_nil, on: :create


  # Instance Methods
  def set_title_to_blank_if_nil
    self.title = "" if self.title.nil?
  end

end
