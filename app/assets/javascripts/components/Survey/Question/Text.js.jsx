/*
 * Dependencies
 */
var classNames = require("classnames");


/*
 * Parent Component
 */
var Survey = window.Survey || {Question: {}};


/*
 * Primary Component
 */
Survey.Question.Text = React.createClass({
  propTypes: {
    setResponseForQuestion: React.PropTypes.func,
    validationErrorMessage: React.PropTypes.string
  },

  render: function() {
    var valid = (this.props.validationErrorMessage === undefined);

    var validationClassNames = classNames({
      "Survey_Question_Text-Invalid": !valid,
      "Survey_Question_Text-Valid": valid
    });

    var errorMessage = "";
    if (!valid) {
      var errorMessage = (
        <span className="Survey_Question_Text-Error-Message">
          {this.props.validationErrorMessage}
        </span>
      )
    }

    return (
      <div className="Survey_Question_Text">
        <div className={validationClassNames}>
          <input type="text" onChange={this.updateResponse} />
          {errorMessage}
        </div>
      </div>
    )
  },

  updateResponse: function(event) {
    this.props.setResponseForQuestion(this.props.id, event.target.value);
  }
});


/*
 * Exports
 */
module.exports = Survey.Question.Text;
