# Public: A collection of useful classes and methods to generate view and
# response logic for SurveysController.
class SurveysView

  # Public: Uses Jbuilder to construct a JSON representation of a Survey for use
  # with the SurveyEditor React component and JSON responses.
  class SurveyEditor
    include Rails.application.routes.url_helpers

    # Attributes
    #
    # Public: Returns the Survey.
    attr_reader :survey


    # Public: Initialize a SurveyJSON.
    #
    # survey - A Survey that will be the source of the Jbuilder template.
    def initialize(survey)
      @survey = survey
    end

    # Public: Return a Hash representation of the template's JSON.
    #
    # Returns Hash representing the template's JSON.
    def as_hash
      template = Jbuilder.new do |json|
        json.id(survey.id)
        json.formAction(survey_path(survey))
        json.initialTitle(survey.title)
        json.initialDescription(survey.description)

        json.initialQuestions(survey.questions.order_by_position) do |question|
          json.formAction(survey_question_path(survey, question))
          json.id(question.id)
          json.title(question.title)
          json.helpText(question.help_text)
          json.questionType(question.question_type)
          json.position(question.position)
          json.data(question.data)
        end
      end

      template.attributes!
    end

  end


  # Public: Uses Jbuilder to construct a JSON representation of a Survey for use
  # with the Survey React component and JSON responses.
  class Survey
    include Rails.application.routes.url_helpers

    # Attributes
    #
    # Public: Returns the Survey.
    attr_reader :survey


    # Public: Initialize a SurveyJSON.
    #
    # survey - A Survey that will be the source of the Jbuilder template.
    def initialize(survey)
      @survey = survey
    end

    # Public: Return a Hash representation of the template's JSON.
    #
    # Returns Hash representing the template's JSON.
    def as_hash
      template = Jbuilder.new do |json|
        json.extract!(survey, :id, :title, :description)

        json.formAction(survey_submissions_path(survey))

        json.questions(survey.questions.order_by_position) do |question|
          json.id(question.id)
          json.title(question.title)
          json.helpText(question.help_text)
          json.questionType(question.question_type)
          json.data(question.data)
        end
      end

      template.attributes!
    end

  end

end
