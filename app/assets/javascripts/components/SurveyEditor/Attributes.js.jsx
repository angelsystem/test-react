/*
 * Parent Component
 */
var SurveyEditor = window.SurveyEditor || {};


/*
 * Primary Component
 */
SurveyEditor.Attributes = React.createClass({
  propTypes: {
    id: React.PropTypes.number.isRequired,
    formAction: React.PropTypes.string.isRequired,
    initialTitle: React.PropTypes.string.isRequired,
    initialDescription: React.PropTypes.string.isRequired,
    editingTitle: React.PropTypes.bool,
    editingDescription: React.PropTypes.bool
  },

  getInitialState: function() {
    return {
      title: this.props.initialTitle,
      description: this.props.initialDescription,
      editingTitle: false,
      editingDescription: false
    }
  },

  componentDidUpdate: function(prevProps, prevState) {
    // When the user clicks the title or description, focus on the edit field.
    if (this.state.editingTitle) {
      React.findDOMNode(this.refs.titleInput).focus();
    } else if (this.state.editingDescription) {
      React.findDOMNode(this.refs.descriptionTextarea).focus();
    }
  },

  render: function() {
    var title;
    if (this.state.editingTitle) {
      title = <input type="text" value={this.state.title} onChange={this.updateTitle} onBlur={this.save} ref="titleInput" />
    } else {
      title = <h2 onClick={this.editTitle}>{this.state.title}</h2>
    };

    var description;
    if (this.state.editingDescription) {
      description = (
        <textarea rows="3" value={this.state.description} onChange={this.updateDescription} onBlur={this.save} ref="descriptionTextarea"></textarea>
      )
    } else {
      var content = this.state.description || <span>Click to add a description</span>
      description = (
        <p onClick={this.editDescription}>
          {content}
        </p>
      )
    };

    return (
      <div className="SurveyEditor_Attributes">
        <div className="SurveyEditor_Attributes-Title">
          <div className="SurveyEditor_Attributes-Title-Column">
            {title}
          </div>
        </div>

        <div className="SurveyEditor_Attributes-Description">
          <div className="SurveyEditor_Attributes-Description-Column">
            {description}
          </div>
        </div>
      </div>
    );
  },

  editTitle: function() {
    this.setState({editingTitle: true});
  },

  updateTitle: function(event) {
    this.setState({title: event.target.value});
  },

  editDescription: function() {
    this.setState({editingDescription: true});
  },

  updateDescription: function(event) {
    this.setState({description: event.target.value});
  },

  save: function() {
    this.setState({
      editingTitle: false,
      editingDescription: false
    });

    $.ajax({
      url: this.props.formAction,
      method: "PATCH",
      data: {
        survey: {
          title: this.state.title,
          description: this.state.description
        }
      }
    });
  },
});


/*
 * Exports
 */
module.exports = SurveyEditor.Attributes;
