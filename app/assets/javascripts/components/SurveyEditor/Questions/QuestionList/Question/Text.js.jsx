/*
 * Parent Component
 */
var SurveyEditor = window.SurveyEditor || {Questions: {QuestionList: {Question: {}}}};


/*
 * Primary Component
 */
SurveyEditor.Questions.QuestionList.Question.Text = React.createClass({
  render: function() {
    return (
      <div className="SurveyEditor_Questions_QuestionList_Question_Text">
        <input type="text" disabled />
      </div>
    )
  }
});


/*
 * Exports
 */
module.exports = SurveyEditor.Questions.QuestionList.Question.Text;
