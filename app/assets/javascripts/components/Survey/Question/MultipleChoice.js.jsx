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
Survey.Question.MultipleChoice = React.createClass({
  propTypes: {
    options: React.PropTypes.array.isRequired,
    otherToggled: React.PropTypes.bool.isRequired,
    setResponseForQuestion: React.PropTypes.func,
    validationErrorMessage: React.PropTypes.string
  },

  render: function() {
    var valid = (this.props.validationErrorMessage === undefined);

    var validationClassNames = classNames({
      "Survey_Question_MultipleChoice-Invalid": !valid,
      "Survey_Question_MultipleChoice-Valid": valid
    });

    var errorMessage = "";
    if (!valid) {
      var errorMessage = (
        <span className="Survey_Question_MultipleChoice-Error-Message">
          {this.props.validationErrorMessage}
        </span>
      )
    }

    var radioOptions = this.props.options.map((option, index) => (
      <RadioOption key={index} index={index} value={option} {...this.props} />
    ));

    var otherComponent = "";
    // Using JSON.parse to coerce otherToggled since it could have been
    // returned from the server as a string.
    var otherToggledBoolean = JSON.parse(this.props.otherToggled);
    if (otherToggledBoolean) {
      otherComponent = <OtherOption key="other" {...this.props} />;
    }

    return (
      <div className="Survey_Question_MultipleChoice">
        <div className={validationClassNames}>
          <div>
            {radioOptions}
          </div>
          <div>
            {otherComponent}
          </div>
          {errorMessage}
        </div>
      </div>
    )
  }
});


var RadioOption = React.createClass({
  propTypes: {
    value: React.PropTypes.string.isRequired,
    setResponseForQuestion: React.PropTypes.func
  },

  render: function() {
    return (
      <div className="Survey_Question_MultipleChoice_RadioOption">
        <label>
          <input checked={this.props.selected} onChange={this.updateResponse} name={`radio-${this.props.id}`} type='radio' value={this.props.value} />
          {this.props.value}
        </label>
      </div>
    )
  },

  updateResponse: function(event) {
    this.props.setResponseForQuestion(this.props.id, event.target.value);
  }
});


var OtherOption = React.createClass({
  propTypes: {
    setResponseForQuestion: React.PropTypes.func
  },

  render: function() {
    return (
      <div className="Survey_Question_MultipleChoice_OtherOption">
        <label>
          <input checked={this.props.selected} onClick={this.focusOnTextInput} name={`radio-${this.props.id}`} ref="radio" type='radio' />
          Other:
          <input type='text' onClick={this.selectRadioInput} onBlur={this.updateResponse} ref="textInput" />
        </label>
      </div>
    )
  },

  selectRadioInput: function(event) {
    React.findDOMNode(this.refs.radio).checked = true;
  },

  focusOnTextInput: function(event) {
    React.findDOMNode(this.refs.textInput).focus();
  },

  updateResponse: function(event) {
    this.props.setResponseForQuestion(this.props.id, event.target.value);
  },
});


/*
 * Exports
 */
module.exports = Survey.Question.MultipleChoice;
