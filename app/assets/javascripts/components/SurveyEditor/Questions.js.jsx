/*
 * Parent Component
 */
var SurveyEditor = window.SurveyEditor || {};


/*
 * Primary Component
 */
SurveyEditor.Questions = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    formAction: React.PropTypes.string.isRequired,
    questions: React.PropTypes.arrayOf(React.PropTypes.object),
    updateQuestionCurrentlyBeingEdited: React.PropTypes.func.isRequired,
    questionBeingEditedId: React.PropTypes.number
  },

  getInitialState: function() {
    return {
      questions: this.props.initialQuestions
    };
  },

  render: function() {
    var surveyQuestionsList = <SurveyEditor.Questions.QuestionList
                                    id={this.props.id}
                                    formAction={this.props.formAction}
                                    questions={this.state.questions}
                                    updateQuestions={this.updateQuestions}
                                    allowRemovalOfComponent={this._canRemoveComponent()}
                                    updateQuestionCurrentlyBeingEdited={this.props.updateQuestionCurrentlyBeingEdited}
                                    questionBeingEditedId={this.props.questionBeingEditedId} />

    var surveyAddQuestion = <SurveyEditor.Questions.AddQuestion
                                id={this.props.id}
                                formAction={this.props.formAction}
                                questions={this.state.questions}
                                updateQuestionCurrentlyBeingEdited={this.props.updateQuestionCurrentlyBeingEdited}
                                updateQuestions={this.updateQuestions} />

    return (
      <div className="SurveyEditor_Questions">
        {surveyQuestionsList}
        {surveyAddQuestion}
      </div>
    );
  },

  updateQuestions: function(questions) {
    this.setState({ questions: questions });
  },


  /*
   * Private Methods
   */

  // Only allow the user to remove a question if the survey has more than one
  // question.
  _canRemoveComponent: function() {
    return this.state.questions.length > 1;
  }
});


/*
 * Child Components
 */
SurveyEditor.Questions.QuestionList = require("./Questions/QuestionList.js.jsx");
SurveyEditor.Questions.AddQuestion = require("./Questions/AddQuestion.js.jsx");


/*
 * Exports
 */
module.exports = SurveyEditor.Questions;
