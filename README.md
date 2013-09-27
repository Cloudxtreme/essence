Essence
=======

Essence lets you manage Timelets - reminders or timers running in your web browser.

About
-----

In short, the application lets you define, manage and run timers in your browser, without the need to create an account and, after the first use, without a connection to the server.

Technical
---------

Essence is a Backbone- and Marionette application running on top of Rails' asset pipeline. The rails application merely bootstraps Markup, CSS and JavaScript into the browser and, once loaded, won't communicate further. Persistance is only achieved via localStorage for the time being. In the future, the Rails backend might be replaced entirely.

Setup
-----

Install [rbenv](https://github.com/sstephenson/rbenv) and the ruby version defined in [.ruby-version](blob/master/.ruby-version).

Then, run install all gems

```
bundle
```

Start the web server

```
rails s
```

