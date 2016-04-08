/*
 * Parent Component
 */
var Survey = window.Survey || {};


/*
 * Primary Component
 */
Survey.Question = React.createClass({
  propTypes: {
    title: React.PropTypes.string.isRequired,
    helpText: React.PropTypes.string,
    questionType: React.PropTypes.string.isRequired,
    data: React.PropTypes.object.isRequired,
    validationErrorMessage: React.PropTypes.string,
    setResponseForQuestion: React.PropTypes.func,
    toggleEditing: React.PropTypes.func
  },

  render: function() {
    var title = this.props.title || "Untitled question";

    var questionTypeComponent = "";
    switch (this.props.questionType) {
      case "Text":
        questionTypeComponent = <Survey.Question.Text {...this.props} />;
        break;
      case "Multiple Choice":
        // Using JSON.parse to coerce otherToggled since it could have been
        // returned from the server as a string.
        var otherToggledBoolean = JSON.parse(this.props.data.otherToggled);
        questionTypeComponent = <Survey.Question.MultipleChoice
            options={this.props.data.options}
            otherToggled={otherToggledBoolean}
            {...this.props} />;
        break;
    }

    return (
      <div className="Survey_Question" onClick={this.props.toggleEditing}>
        <div className="Survey_Question-Title">
          <h4>{title}</h4>
        </div>
        <div className="Survey_Question-Help-Text">
          <p>{this.props.helpText}</p>
        </div>
        <div className="Survey_Question-Response">
          {questionTypeComponent}
        </div>
      </div>
    )
  }
});


/*
 * Child Components
 */
Survey.Question.MultipleChoice = require("./Question/MultipleChoice.js.jsx");
Survey.Question.Text = require("./Question/Text.js.jsx");


/*
 * Exports
 */
module.exports = Survey.Question;
