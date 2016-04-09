/*
 * Dependencies
 */
// Library for drag/drop to sort the questions. Documentation:
// https://github.com/samvtran/react-sortable-items
var Sortable = require("react-sortable-items");
var Modal = require("../../lib/Modal.js.jsx");


/*
 * Parent Component
 */
var SurveyEditor = window.SurveyEditor || {Questions: {}};


/*
 * Primary Component
 */
SurveyEditor.Questions.QuestionList = React.createClass({
  propTypes: {
    formAction: React.PropTypes.string.isRequired,
    questions: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
    allowRemovalOfComponent: React.PropTypes.bool.isRequired,
    questionBeingEditedId: React.PropTypes.number,
    updateQuestionCurrentlyBeingEdited: React.PropTypes.func.isRequired
  },

  getInitialState: function() {
    return {
      displayRemoveQuestionModal: false
    };
  },

  render: function() {
    // Questions are draggable unless one of them is being updated. If
    // questionBeingEditedId is null, that means no questions are being
    // updated and we're safe to drag.
    var isDraggable = (this.props.questionBeingEditedId === null);

    var modal;
    if (this.state.displayRemoveQuestionModal) {
      modal = <Modal title="Are you sure you want to remove this question?"
                 helpText="This action cannot be undone."
                 primaryButtonText="Remove Question"
                 onDismissAction={this.dismissModal}
                 onSuccessAction={this.deleteQuestionFromServer} />
    }

    var questions = this.props.questions.map((question, index) => (
      <SurveyEditor.Questions.QuestionList.Question
          key={index}
          sortData={index}
          isDraggable={isDraggable}
          allowRemovalOfComponent={this.props.allowRemovalOfComponent}
          questionBeingEditedId={this.props.questionBeingEditedId}
          updateQuestionCurrentlyBeingEdited={this.props.updateQuestionCurrentlyBeingEdited}
          onClickUpdateQuestion={this.saveQuestion}
          onClickRemoveQuestion={this.displayRemoveQuestionConfirmationModal}
          {...question} />
    ));

    return (
      <div className="SurveyEditor_Questions_QuestionList">
        {modal}
        <Sortable onSort={this.handleSort}>
          {questions}
        </Sortable>
      </div>
    );
  },

  handleSort: function(newSortedIndices) {
    this.props.updateQuestions(newSortedIndices.map((index) => (
      this.props.questions[index]
    )));
    this._saveSurvey();
  },

  updateQuestionCurrentlyBeingEdited: function(questionBeingEditedId) {
    this.props.updateQuestionCurrentlyBeingEdited(questionBeingEditedId);
  },

  saveQuestion: function(questionId, updatedAttributes) {
    var questions = this.props.questions;

    // Update the question with the new attributes.
    var updatedQuestion = _.extend(this._findQuestionById(questionId), updatedAttributes);

    // Optimistically update the questions list with the updated question
    // (before hitting the server).
    this._updateQuestionInQuestionsState(updatedQuestion);

    // Update the question on the server.
    $.ajax({
      url: updatedQuestion.formAction,
      method: "PATCH",
      dataType: "JSON",
      data: {
        question: {
          title: updatedQuestion.title,
          help_text: updatedQuestion.helpText,
          question_type: updatedQuestion.questionType,
          data: updatedQuestion.data
        }
      },
      success: function(updatedQuestion) {
        this._updateQuestionInQuestionsState(updatedQuestion);
      }.bind(this)
    });
  },

  displayRemoveQuestionConfirmationModal: function() {
    this.setState({displayRemoveQuestionModal: true});
  },

  dismissModal: function() {
    this.setState({displayRemoveQuestionModal: false});
  },

  deleteQuestionFromServer: function() {
    // Remove the question on the server.
    var question = this._findQuestionById(this.props.questionBeingEditedId);
    $.ajax({
      url: question.formAction,
      method: "DELETE",
      dataType: "JSON",
      success: function(removedQuestion) {
        this._removeQuestionFromQuestionsStateById(removedQuestion.id);
        this.setState({displayRemoveQuestionModal: false});
      }.bind(this)
    });
  },


  /*
   * Private Methods
   */
  _updateQuestionInQuestionsState: function(updatedQuestion) {
    var questions = this.props.questions;

    this.props.updateQuestions(_.each(questions, function(question) {
      if(question.id == updatedQuestion.id) return updatedQuestion;
      return question;
    }));
  },

  _removeQuestionFromQuestionsStateById: function(questionId) {
    var questions = this.props.questions;

    this.props.updateQuestions(_.reject(questions, function(question) {
      return question.id == questionId;
    }));
  },

  _saveSurvey: function() {
    $.ajax({
      url: this.props.formAction,
      method: "PATCH",
      data: { survey: {
          question_order: _.pluck(this.props.questions, 'id')
        }
      }
    });
  },

  _findQuestionById: function(questionId) {
    return _.find(this.props.questions, function(question) {
      return question.id == questionId;
    });
  }
});


/*
 * Child Components
 */
SurveyEditor.Questions.QuestionList.Question = require("./QuestionList/Question.js.jsx");


/*
 * Exports
 */
module.exports = SurveyEditor.Questions.QuestionList;
