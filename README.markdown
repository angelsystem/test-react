## Formidable

Formidable is a form-building platform that allows users to quickly build and share forms as well as review the submitted responses. We created this application to use as an exercise for both design and engineering candidates.

It's built using Ruby on Rails and [React](https://facebook.github.io/react/). The [react-rails](https://github.com/reactjs/react-rails) gem is used to render our React components server-side.

The app is structured like a traditional Rails app with one notable exception: [app/views](app/views) doesn't contain typical Rails views. Instead, in the views folder you'll find useful classes and methods to generate view and response logic. The traditional view files can be found in [app/templates](app/templates).

A running version of the app can be found at [http://formidable.able.co/](http://formidable-app.herokuapp.com/).

## Process Overview

This copy of Formidable was generated just for your interview. Over the next three days, please spend no more than 10 hours working on the GitHub issues that we've created for you, starting with the issues labeled "Required." Feel free to complete as many or as few of the optional issues as you'd like to further demonstrate your proficiency and range as a developer.

Our goal is to evaluate your skills and familiarity with some common technologies that we use at Able. We understand that you might not be familiar with all the technologies used but our hope is that you'll be able to follow the patterns we've established.

Just as you would with a real app in production, instead of committing directly to master, you should work on each issue in a new branch and [create a pull request](https://help.github.com/articles/using-pull-requests/#before-you-begin) for us to review and merge. Please follow the existing coding processes, test any new features that you might add, and have the pull requests created by midnight on the day they're due.

Questions related to the issues can be asked directly in the issue's comments. For any other questions you can email engineering@able.co.

## Setup
```
npm install
bundle install
rake db:create
rake db:migrate
rails s
```

Or, you can setup using Vagrant:
```
librarian-chef install
vagrant up
vagrant ssh
cd /vagrant/
rails s -b 0.0.0.0
```

### Dependencies
* Ruby 2.2.2
* npm >= 2.0.0
* Postgres >= 9.4.0
* PhantomJS >= 2.0.0

### Helpful Resources

* [React Documentation](https://facebook.github.io/react/docs/getting-started.html)
* [Thinking in React](https://facebook.github.io/react/docs/thinking-in-react.html)