class RenameFormModels < ActiveRecord::Migration
  def change
    rename_table :forms, :surveys
    rename_table :form_components, :survey_components
    rename_table :form_responses, :survey_responses
    rename_table :form_submissions, :survey_submissions
  end
end
