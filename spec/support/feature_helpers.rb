module FeatureHelpers

  def sign_in
    pw = "password"
    admin = create(:admin, password: pw)
    fill_out_and_submit_sign_in(admin.email, pw)
  end

  def fill_out_and_submit_sign_in(email, password)
    visit(sign_in_path)
    find("h1", text: "Sign In") # Ensure sign in page is loaded.
    fill_in("Email Address", with: email)
    fill_in("Password", with: password)
    click_on("Sign In")
  end

  def create_new_survey
    visit(root_path)
    click_on("Create New Survey")
  end

  def add_multiple_choice_question
    click_on("Add Multiple Choice Question")
    # Wait for multiple choice question to appear.
    find(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice")
  end

  def add_multiple_choice_option
    find(".SurveyEditor_Questions_QuestionList_Question_MultipleChoice-Add-Option input[type=text]").click
  end

  def add_text_question
    click_on("Add Text Question")
    # Wait for text question to appear.
    find(".SurveyEditor_Questions_QuestionList_Question_Text")
  end

end
