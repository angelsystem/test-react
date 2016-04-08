/*
 * Dependencies
 */
// Library used for drag/drop to sort the options. Documentation:
// https://github.com/jasonslyvia/react-anything-sortable
var Sortable = require("react-sortable-items");

// Mixin used for sorting the options. Documentation:
// https://github.com/samvtran/react-sortable-items
var SortableMixin = require("react-sortable-items/SortableItemMixin");


/*
 * Parent Component
 */
var SurveyEditor = window.SurveyEditor || {Questions: {QuestionList: {Question: {}}}};


/*
 * Primary Component
 */
SurveyEditor.Questions.QuestionList.Question.MultipleChoice = React.createClass({
  propTypes: {
    options: React.PropTypes.array.isRequired,
    otherToggled: React.PropTypes.bool.isRequired,
    updateTemporaryData: React.PropTypes.func.isRequired
  },

  render: function() {
    var radioOptions = this.props.options.map((option, index) => (
      <RadioOption
          key={index}
          sortData={index}
          index={index}
          isDraggable={true}
          value={option}
          onChangeRadioOptionInput={this.updateRadioOption}
          onClickRemoveRadioOption={this.removeRadioOption} />
    ));

    var addOtherOption = "";
    var otherOption = "";
    if (this.props.otherToggled) {
      otherOption = <OtherOption onClickToggleOtherOption={this.onClickToggleOtherOption} />;
    } else {
      addOtherOption = <span>or <a href="#" onClick={this.onClickToggleOtherOption}>Add "Other"</a></span>;
    };

    return (
      <div className="SurveyEditor_Questions_QuestionList_Question_MultipleChoice">
        <Sortable onSort={this.handleSortRadioOptions}>
          {radioOptions}
        </Sortable>

        <div className="SurveyEditor_Questions_QuestionList_Question_MultipleChoice-Add-Option">
          <label>
            <input type="radio" readOnly />
            <input type="text" readOnly placeholder="Click to add option" onFocus={this.onFocusAddRadioOption} />
          </label>

          {addOtherOption}
        </div>

        {otherOption}
      </div>
    )
  },


  /*
   * Actions
   */
  onFocusAddRadioOption: function(event) {
    event.preventDefault();

    var updatedOptions = this.props.options;
    updatedOptions.push("Option " + (updatedOptions.length + 1));

    this.props.updateTemporaryData({options: updatedOptions});
  },

  onClickToggleOtherOption: function(event) {
    event.preventDefault();

    var otherToggled = this.props.otherToggled;

    this.props.updateTemporaryData({otherToggled: !otherToggled});
  },

  handleSortRadioOptions: function(newSortedIndices) {
    var updatedOptions = newSortedIndices.map((index) => (
      this.props.options[index]
    ));

    this.props.updateTemporaryData({options: updatedOptions});
  },

  updateRadioOption: function(optionIndexToUpdate, newOptionValue) {
    var updatedOptions = this.props.options;
    updatedOptions[optionIndexToUpdate] = newOptionValue;

    this.props.updateTemporaryData({options: updatedOptions});
  },

  removeRadioOption: function(optionIndexToRemove) {
    var updatedOptions = _.reject(this.props.options, function(option, index) {
      return index == optionIndexToRemove;
    });

    this.props.updateTemporaryData({options: updatedOptions});
  }
});


var RadioOption = React.createClass({
  mixins: [SortableMixin],

  propTypes: {
    value: React.PropTypes.string.isRequired,
    index: React.PropTypes.number.isRequired,
    onChangeRadioOptionInput: React.PropTypes.func.isRequired,
    onClickRemoveRadioOption: React.PropTypes.func.isRequired
  },

  componentDidMount: function() {
    // Highlight the input for the last option that's been added.
    React.findDOMNode(this.refs.optionValue).select();
  },

  render: function() {
    return this.renderWithSortable(
      <div className="SurveyEditor_Questions_QuestionList_Question_MultipleChoice_RadioOption">
        <label>
          <input type="radio" readOnly />
          <input type="text" ref="optionValue" value={this.props.value} onChange={this.onChangeRadioOptionInput} />
          <a onClick={this.onClickRemoveRadioOption}><span></span></a>
        </label>
      </div>
    )
  },


  /*
   * Actions
   */
  onChangeRadioOptionInput: function(event) {
    event.preventDefault();

    this.props.onChangeRadioOptionInput(this.props.index, event.target.value);
  },

  onClickRemoveRadioOption: function(event) {
    event.preventDefault();

    this.props.onClickRemoveRadioOption(this.props.index);
  },
});


var OtherOption = React.createClass({
  propTypes: {
    onClickToggleOtherOption: React.PropTypes.func.isRequired
  },

  render: function() {
    return (
      <div className="SurveyEditor_Questions_QuestionList_Question_MultipleChoice_OtherOption">
        <label>
          <input type="radio" readOnly />
          Other: <input type="text" readOnly />
          <a href="#" onClick={this.props.onClickToggleOtherOption}><span></span></a>
        </label>
      </div>
    )
  }
});


/*
 * Exports
 */
module.exports = SurveyEditor.Questions.QuestionList.Question.MultipleChoice;
