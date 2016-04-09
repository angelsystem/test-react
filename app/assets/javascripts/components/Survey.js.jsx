/*
 * Primary Component
 */
var Survey = React.createClass({
  propTypes: {
    formAction: React.PropTypes.string.isRequired,
    questions: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
  },

  getInitialState: function() {
    var initialResponses = {};
    this.props.questions.forEach(question => {
      initialResponses[question.id] = "";
    });

    return {
      authenticityToken: null,
      responses: initialResponses,
      showValidationErrors: false
    };
  },

  componentDidMount: function() {
    // TODO Grabbing the authenticity token here feels hack-y!
    var token = $("meta[name='csrf-token']").attr('content');
    this.setState({authenticityToken: token});
  },

  render: function() {
    var questions = this.props.questions.map((question) => {
        var validationErrorMessage;
        if (this.state.showValidationErrors) {
          validationErrorMessage = this._errorForResponse(question.id);
        }

        return <Survey.Question
            key={question.id}
            validationErrorMessage={validationErrorMessage}
            setResponseForQuestion={this.setResponseForQuestion}
            {...question} />
    });

    return (
      <form className="Survey" onSubmit={this.handleSubmit}>
        <input name="authenticity_token" type="hidden" defaultValue={this.state.authenticityToken} />

        {questions}

        <input type="submit" />
      </form>
    )
  },

  handleSubmit: function(event) {
    event.preventDefault();

    if (!this.isValid()) {
      this.setState({showValidationErrors: true});
      return;
    }

    this.setState({showValidationErrors: false});

    $.ajax({
      url: this.props.formAction,
      method: "POST",
      dataType: "JSON",
      data: {
        submission: {
          responses_attributes: this._responsesArrayToParams()
        }
      },
      success: function(submission) {
        // TODO This location should be returned by the server.
        window.location = window.location.href + "/confirmation";
      }
    });
  },

  // The form's valid if all the responses have values.
  // _.every - Returns true if all of the values in the list pass the predicate
  //           truth test.
  isValid: function() {
    var responseValues = _.values(this.state.responses);
    return _.every(responseValues);
  },

  setResponseForQuestion: function(questionId, response) {
    var responses = this.state.responses;
    responses[questionId] = response;
    this.setState({responses: responses});
  },


  /*
   * Private Methods
   */
  // Returns a String
  _errorForResponse: function(questionId) {
    var error;

    if (this.state.responses[questionId].trim("") === "") {
      error = "This field is required.";
    }

    return error;
  },

  _responsesArrayToParams: function() {
    return _.collect(this.state.responses, function(value, key) {
      return { survey_question_id: key, answer: value }
    });
  }
});


/*
 * Child Components
 */
Survey.Question = require("./Survey/Question.js.jsx");


/*
 * Exports
 */
module.exports = Survey;
