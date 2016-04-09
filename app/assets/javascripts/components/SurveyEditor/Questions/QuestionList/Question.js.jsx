/*
 * Dependencies
 */
// Used to display a preview of the survey question.
var Survey = window.Survey || {Question: {}};

// Mixin used for sorting the options. Documentation:
// https://github.com/samvtran/react-sortable-items
var SortableMixin = require("react-sortable-items/SortableItemMixin");


/*
 * Parent Component
 */
var SurveyEditor = window.SurveyEditor || {Questions: {QuestionList: {}}};


/*
 * Primary Component
 */
SurveyEditor.Questions.QuestionList.Question = React.createClass({
  mixins: [SortableMixin],

  propTypes: {
    id: React.PropTypes.number,
    questionBeingEditedId: React.PropTypes.number,
    title: React.PropTypes.string,
    helpText: React.PropTypes.string,
    questionType: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    toggleEditing: React.PropTypes.func,
    allowRemovalOfComponent: React.PropTypes.bool.isRequired,
    updateQuestionCurrentlyBeingEdited: React.PropTypes.func.isRequired
  },

  render: function() {
    // Only one question can be edited at a time so, we delegate that
    // responsibility to our parent which has knowledge of all the questions'
    // props.
    var questionCurrentlyBeingEdited = (this.props.id === this.props.questionBeingEditedId);

    var question;
    if (questionCurrentlyBeingEdited) {
      question = <EditableSurveyQuestion
          onClickSave={this.updateAndCancelEditing}
          onClickRemove={this.removeAndCancelEditing}
          onClickDiscard={this.discardChangesAndCancelEditing}
          {...this.props} />;
    } else {
      question = <Survey.Question
          toggleEditing={this.updateQuestionCurrentlyBeingEdited}
          {...this.props} />;
    }

    return this.renderWithSortable(
      <div className="SurveyEditor_Questions_QuestionList_Question">
        {question}
      </div>
    );
  },


  /*
   * Actions
   */
  updateQuestionCurrentlyBeingEdited: function() {
    this.props.updateQuestionCurrentlyBeingEdited(this.props.id);
  },

  updateAndCancelEditing: function(updatedAttributes) {
    event.preventDefault();

    this.cancelEditing();
    this.props.onClickUpdateQuestion(this.props.id, updatedAttributes);
  },

  removeAndCancelEditing: function(event) {
    event.preventDefault();

    if (this.props.allowRemovalOfComponent) {
      this.props.onClickRemoveQuestion();
    } else {
      alert("Sorry, you must have at least one component");
    }
  },

  discardChangesAndCancelEditing: function(event) {
    event.preventDefault();
    this.cancelEditing();
  },

  cancelEditing: function() {
    if (this.props.id === this.props.questionBeingEditedId) {
      this.props.updateQuestionCurrentlyBeingEdited(null);
    };
  }
});


var EditableSurveyQuestion = React.createClass({
  getInitialState: function() {
    return {
      temporaryQuestionType: this.props.questionType,
      temporaryData: this.props.data
    };
  },

  componentDidMount: function() {
    // Focus on the title when we first start editing.
    React.findDOMNode(this.refs.title).focus();
  },

  render: function() {
    var questionTypeComponent;
    switch (this.state.temporaryQuestionType) {
      case "Text":
        questionTypeComponent = <SurveyEditor.Questions.QuestionList.Question.Text />;
        break;
      case "Multiple Choice":
        // Using JSON.parse to coerce otherToggled since it could have been
        // returned from the server as a string.
        var otherToggledBoolean = JSON.parse(this.state.temporaryData.otherToggled);
        questionTypeComponent = <SurveyEditor.Questions.QuestionList.Question.MultipleChoice
                                    options={this.state.temporaryData.options}
                                    otherToggled={otherToggledBoolean}
                                    updateTemporaryData={this.updateTemporaryData} />;
        break;
    };

    return (
      <div className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion">
        <div className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Title">
          <label>Question Title</label>
          <input type="text" defaultValue={this.props.title} ref="title" />
        </div>

        <div className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Help-Text">
          <label>Help Text</label>
          <input type="text" defaultValue={this.props.helpText} ref="helpText" />
        </div>

        <div className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Type">
          <label>Question Type</label>
          <select value={this.state.temporaryQuestionType} onChange={this.updateTemporaryQuestionType} ref="temporaryQuestionType">
            <option value="Text">Text</option>
            <option value="Multiple Choice">Multiple Choice</option>
          </select>
        </div>

        <div className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Response">
          <label>Response</label>
          {questionTypeComponent}
        </div>

        <div className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Actions">
          <a className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Actions-Save-Changes" href="#" onClick={this.collectUpdatedAttributesAndSave}>Save</a>
          <a className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Actions-Discard-Changes" href="#" onClick={this.props.onClickDiscard}>Discard Changes</a>
          <a className="SurveyEditor_Questions_QuestionList_Question_EditableSurveyQuestion-Actions-Remove-Question" href="#" onClick={this.props.onClickRemove}>Remove Question</a>
        </div>
      </div>
    )
  },

  collectUpdatedAttributesAndSave: function(event) {
    event.preventDefault();

    updatedAttributes = {
      title: React.findDOMNode(this.refs.title).value,
      helpText: React.findDOMNode(this.refs.helpText).value,
      questionType: this.state.temporaryQuestionType,
      data: this.state.temporaryData
    }

    this.props.onClickSave(updatedAttributes);
  },

  updateTemporaryQuestionType: function(event) {
    var temporaryQuestionType = React.findDOMNode(this.refs.temporaryQuestionType).value;

    // Since the user can switch the questionType to one that requires data
    // attributes to be set, we're going to set them here. If the type doesn't
    // require any data attributes, we clear the temporaryData from state.
    //
    // Feels like a hack-y place to bury this logic.
    switch (temporaryQuestionType) {
      case "Text":
        this.setState({temporaryData: {}});
        break;
      case "Multiple Choice":
        this.setState({temporaryData: {options: ["Option 1"], otherToggled: false}});
        break;
    };

    this.setState({temporaryQuestionType: temporaryQuestionType});
  },

  updateTemporaryData: function(updatedTemporaryData) {
    var temporaryData = this.state.temporaryData;
    this.setState({temporaryData: _.extend(temporaryData, updatedTemporaryData)});
  }
});


/*
 * Child Components
 */
SurveyEditor.Questions.QuestionList.Question.MultipleChoice = require("./Question/MultipleChoice.js.jsx");
SurveyEditor.Questions.QuestionList.Question.Text = require("./Question/Text.js.jsx");


/*
 * Exports
 */
module.exports = SurveyEditor.Questions.QuestionList.Question;
