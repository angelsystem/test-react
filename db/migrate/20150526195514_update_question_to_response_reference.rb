class UpdateQuestionToResponseReference < ActiveRecord::Migration
  def change
    remove_reference :survey_responses, :survey_component

    add_reference :survey_responses, :survey_question, index: true, foreign_key: true
  end
end
