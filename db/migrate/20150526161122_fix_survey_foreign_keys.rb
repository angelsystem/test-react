class FixSurveyForeignKeys < ActiveRecord::Migration
  def change
    remove_reference :survey_components,  :form
    remove_reference :survey_responses,   :form_component
    remove_reference :survey_responses,   :form_submission
    remove_reference :survey_submissions, :form

    add_reference :survey_components,  :survey, index: true, foreign_key: true
    add_reference :survey_responses,   :survey_component, index: true, foreign_key: true
    add_reference :survey_responses,   :survey_submission, index: true, foreign_key: true
    add_reference :survey_submissions, :survey, index: true, foreign_key: true
  end
end
