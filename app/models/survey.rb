# Public: A survey is a simple parent object that links a collection of
# +questions+. Surveys accept +submissions+.
#
# Examples:
#
#   Survey.create
#   # => #<Survey id: 1, title: "Untitled", description: null, ...>
#
#   survey = Survey.create(title: "My Survey", ...)
#   # => #<Survey id: 2, title: "My Survey", ...>
#   survey.questions.create(title: "What's your name?", ...)
#   # => #<SurveyQuestion id: 1, survey_id: 2, ...>
#   survey.submissions.create(response: "John Smith", ...)
#   # => #<SurveySubmission id: 1, survey_id: 2, ...>
class Survey < ActiveRecord::Base

  # Associations
  has_many :questions, class_name: "SurveyQuestion", inverse_of: :survey, dependent: :destroy
  has_many :submissions, class_name: "SurveySubmission", inverse_of: :survey, dependent: :destroy


  # Validations
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true


  # Callbacks
  before_validation :set_default_title, on: :create
  before_validation :set_default_description, on: :create
  before_validation :generate_slug, on: :create


  # Public: Sets the +question_order+ using a passed in array of question IDs.
  #
  # question_order - An Array of SurveyQuestion IDs (as strings).
  #
  # Examples:
  #
  #   survey.question_order = ["5", "15", "14"]
  #
  # Returns nothing.
  def question_order=(question_order)
    questions.each do |question|
      new_position = question_order.index(question.id.to_s)
      next unless new_position
      question.update(position: new_position)
    end
  end


  private

  # Internal: If a title isn't set when the survey is created, we'll assign
  # one ("Untitled survey"). We're actually assigning the value in the database
  # since a) this default might change and b) for users, it shouldn't change
  # if the default changes.
  #
  # Examples
  #
  #   Survey.create
  #   # => #<Survey id: 1, title: "Untitled survey", ...>
  #
  #   Survey.create(title: "My Awesome Title")
  #   # => #<Survey id: 1, title: "My Awesome Title", ...>
  #
  # Returns nothing.
  def set_default_title
    self.title = "Untitled survey" if title.blank?
  end

  # Internal: If a description isn't set when the survey is created, we'll assign
  # one. We're actually assigning the value in the database # since a) this
  # default might change and b) for users, it shouldn't change if the default
  # changes.
  #
  # Returns nothing.
  def set_default_description
    self.description = "You can plan events, make a survey or poll, give students
                        a quiz, or collect other information in an easy, streamlined way with
                        Formidable" if description.blank?
  end

  # Internal: Generate a URL friendly, +slug+ and assign it to the survey when
  # it's created. We test to see that the slug is unique before assignment.
  #
  # Examples
  #
  #   Survey.create
  #   # => #<Survey id: 1, ..., slug: "oBYcBf5MhYbq4GnL", ...>
  #
  # Returns nothing.
  def generate_slug
    self.slug = loop do
      slug = SecureRandom.base64(12).tr('+/=', 'azyb')
      break slug unless self.class.exists?(slug: slug)
    end
  end

end
