//= require underscore
//= require_self

// Use React's Node Module vs. the version maintained in react-rails so that
// we can use Jest in the future.
// Read more: https://reactjsnews.com/setting-up-rails-for-react-and-jest/
React         = require("react");


/*
 * Components
 */
Survey        = require("./components/Survey.js.jsx");
SurveyEditor  = require("./components/SurveyEditor.js.jsx");
