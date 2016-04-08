require "rails_helper"

RSpec.describe SurveySubmission, type: :model do

  describe "associations" do
    it { is_expected.to belong_to(:survey).inverse_of(:submissions) }
    it { is_expected.to have_many(:responses).class_name("SurveyResponse").inverse_of(:submission).dependent(:destroy) }
  end

  describe "nested attributes" do
    it { is_expected.to accept_nested_attributes_for(:responses) }
  end

end
