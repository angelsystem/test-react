/*
 * Primary Component
 */
var SurveyEditor = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    formAction: React.PropTypes.string.isRequired,
    initialTitle: React.PropTypes.string.isRequired,
    initialDescription: React.PropTypes.string.isRequired,
    initialQuestions: React.PropTypes.arrayOf(React.PropTypes.object).isRequired
  },

  getInitialState: function() {
    return {
      questionBeingEditedId: null
    };
  },

  render: function() {
    var surveyAttributesComponent = <SurveyEditor.Attributes
                                        id={this.props.id}
                                        formAction={this.props.formAction}
                                        initialTitle={this.props.initialTitle}
                                        initialDescription={this.props.initialDescription}
                                        updateQuestionCurrentlyBeingEdited={this.updateQuestionCurrentlyBeingEdited} />

    var surveyQuestions = <SurveyEditor.Questions
                              id={this.props.id}
                              formAction={this.props.formAction}
                              initialQuestions={this.props.initialQuestions}
                              updateQuestionCurrentlyBeingEdited={this.updateQuestionCurrentlyBeingEdited}
                              questionBeingEditedId={this.state.questionBeingEditedId} />

    return (
      <div className="SurveyEditor">
        {surveyAttributesComponent}
        {surveyQuestions}
      </div>
    );
  },

  updateQuestionCurrentlyBeingEdited: function(questionBeingEditedId) {
    this.setState({questionBeingEditedId: questionBeingEditedId});
  }
});


/*
 * Child Components
 */
SurveyEditor.Attributes = require("./SurveyEditor/Attributes.js.jsx");
SurveyEditor.Questions = require("./SurveyEditor/Questions.js.jsx");


/*
 * Exports
 */
module.exports = SurveyEditor;
