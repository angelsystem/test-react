class RenameSurveyComponent < ActiveRecord::Migration
  def change
    rename_table :survey_components, :survey_questions
  end
end
