/*
 * Primary Component
 */
Modal = React.createClass({
  propTypes: {
    title: React.PropTypes.string.isRequired,
    helpText: React.PropTypes.string,
    primaryButtonText: React.PropTypes.string.isRequired,
    onSuccessAction: React.PropTypes.func.isRequired,
    onDismissAction: React.PropTypes.func.isRequired
  },

  render: function() {
    return (
      <div className="Modal">
        <div className="Modal-Dialog">
          <div className="Modal-Content">
            <div className="Modal-Header">
              <h4>{this.props.title}</h4>
            </div>
            <div className="Modal-Body">
              <p>{this.props.helpText}</p>
            </div>
            <div className="Modal-Footer">
              <button onClick={this.props.onDismissAction}>Cancel</button>
              <button onClick={this.props.onSuccessAction}>{this.props.primaryButtonText}</button>
            </div>
          </div>
        </div>
      </div>
    )
  }
});


/*
 * Exports
 */
module.exports = Modal;
