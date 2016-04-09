Rails.application.routes.draw do

  # Registrations
  get   "register" => "admin_registrations#new"
  post  "register" => "admin_registrations#create"


  # AdminSessions
  get   "sign_in"   => "admin_sessions#new"
  post  "sign_in"   => "admin_sessions#create"
  get   "sign_out"  => "admin_sessions#destroy"


  # Surveys
  resources :surveys, only: [:create, :edit, :update, :destroy] do
    # SurveyQuestions
    resources :questions, only: [:create, :update, :destroy], controller: "survey_questions"

    # SurveySubmissions
    resources :submissions, only: [:index, :create], controller: "survey_submissions"
  end
  get "/surveys/:survey_id" => "survey_submissions#new", as: "new_survey_submission"
  get "/surveys/:survey_id/confirmation" => "survey_submissions#confirmation", as: "confirmation_survey_submission"
  root "surveys#index"

end
