# Base controller class for Marionette Modules
#
class Essence.Controller

  # Helper to ensure we have an authenticated user, otherwise
  # redirect to the login page.
  #
  # When the user is authenticated, it also calls the controller `setup` function.
  #
  # @param [Function] callback the callback function that takes the authenticated user and the current company as param
  #
  authenticated: (callback) ->
    Essence.application.loginUser().done (user) =>
      @setup() if @setup
      callback(user, user.get('current_company'))

    Essence.application.loginUser().fail ->
      Backbone.history.navigate "/users/login/redirect/#{ window.location.pathname }", { trigger: true, replace: false }
