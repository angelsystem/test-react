FactoryGirl.define do

  # Sequences
  sequence :email do |n|
    "louie#{n}@able.co"
  end


  # Factories
  factory :admin do
    email
    password "turchoie"
  end

  factory :survey do
    title Faker::Lorem.sentence
    description Faker::Lorem.sentence
  end

  factory :survey_question do
    title Faker::Lorem.sentence
    help_text Faker::Lorem.sentence
    text

    trait :text do
      question_type "Text"
    end

    trait :multiple_choice do
      question_type "Multiple Choice"
    end
  end

  factory :survey_response do
    answer "yes"
  end

  factory :survey_submission do
    before(:create) do |submission|
      submission.responses << build(:survey_response)
    end
  end
end
