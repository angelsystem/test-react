/*
 * Parent Component
 */
var SurveyEditor = window.SurveyEditor || {Questions: {}};


/*
 * Primary Component
 */
SurveyEditor.Questions.AddQuestion = React.createClass({
  propTypes: {
    questions: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    updateQuestionCurrentlyBeingEdited: React.PropTypes.func.isRequired
  },

  render: function() {
    return (
      <div className="SurveyEditor_Questions_AddQuestion">
        <h4>Add a Question</h4>

        <ul>
          <li className="SurveyEditor_Questions_AddQuestion-Multiple-Choice">
            <a href="#" onClick={this.addQuestion.bind(this, "Multiple Choice")}>
              Add Multiple Choice Question
            </a>
          </li>
          <li className="SurveyEditor_Questions_AddQuestion-Text">
            <a href="#" onClick={this.addQuestion.bind(this, "Text")}>
              Add Text Question
            </a>
          </li>
        </ul>
      </div>
    )
  },


  /*
   * Actions
   */
  addQuestion: function(questionType, event) {
    event.preventDefault();

    var questions = this.props.questions;
    var newQuestionOptimisticId = Math.random().toString(36);

    var newQuestion = $.extend(this._defaultQuestionAttributes(questionType), {
      optimisticId: newQuestionOptimisticId
    });

    // Optimistically update the questions list with the new question
    // (before sending it to the server).
    questions.push(newQuestion);
    this.setState({questions: questions});
    this.props.updateQuestions(questions);

    // Create the question on the server.
    $.ajax({
      url: `/surveys/${this.props.id}/questions`,
      method: "POST",
      dataType: "JSON",
      data: {
        question: {
          title: newQuestion.title,
          help_text: newQuestion.helpText,
          question_type: newQuestion.questionType,
          position: newQuestion.position,
          data: newQuestion.data
        }
      },
      success: function(newQuestion) {
        var questions = this.props.questions;
        var c = _.each(questions, function(question) {
          if(question.optimisticId == newQuestionOptimisticId) {
            return _.extend(question, newQuestion);
          }
          return question;
        });
        this.setState({questions: c});
        this.props.updateQuestionCurrentlyBeingEdited(newQuestion.id);
        this.props.updateQuestions(c);
      }.bind(this)
    });
  },


  /*
   * Private Methods
   */
  _defaultQuestionAttributes: function(questionType) {
    var attributes = {
      title: "Default Title",
      helpText: "",
      questionType: questionType,
      defaultToEditing: true,
      position: this.props.questions.length,
      data: {}
    }

    if (questionType == "Multiple Choice") {
      attributes = _.extend(attributes, {
        data: {
          options: ["Option 1"],
          otherToggled: false
        }
      })
    }

    return attributes;
  }
});


/*
 * Exports
 */
module.exports = SurveyEditor.Questions.AddQuestion;
