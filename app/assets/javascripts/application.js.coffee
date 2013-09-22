#= require i18n
#= require jquery
#= require jquery_ujs
#= require underscore
#= require moment
#= require hamlcoffee
#= require backbone
#= require backbone.marionette
#= require backbone/backbone-forms/backbone-forms
#= require backbone/backbone-forms/list
#= require backbone/deep-model
#= require backbone/backbone.collectionsubset
#= require select2
#
#= require ./lib/namespaces
#= require ./lib/backbone/history
#= require_tree ./lib
#= require_tree ./shared/models
#= require_tree ./shared/collections
#= require_tree ./shared/templates
#= require_tree ./shared/views/items
#= require_tree ./shared/views/collections
#= require_tree ./shared/views
#
#= require ./modules/timelet/timelet
#
#= require_self

# Essence Marionette Application
#
class Essence.Application extends Essence.Controller

  # Defines the url routes the base app will handle.
  #
  class @Router extends Backbone.Marionette.AppRouter
    appRoutes:
      ''                 : 'handleDefaultRoute'
      'login/:id/:token' : 'loginIntegrationSpec'

  # Create the Marionette application and registers
  # its modules.
  #
  constructor: ->
    window.App = new Backbone.Marionette.Application()

    App.addRegions container: '#container'
    App.module 'Timelet', new Essence.Timelet()
    App.addInitializer @initialize

  # Initializes the Essence app
  #
  initialize: =>
    @setLocale()
    @authenticateAPI()
    @setRenderer()
    @enablePushStateNavigation()

    @router = new Essence.Application.Router(controller: @)

    # Define a fallback route
    #
    @router.route '*url', @handleFallbackRoute

    # Add the fallback route at the end of the handlers so it gets
    # checked last.
    #
    fallbackRoute = Backbone.history.handlers.shift()
    Backbone.history.handlers.push fallbackRoute

  # Start the application and the history router.
  #
  # This sets the authorization token before starting the app,
  # but an `authorization_token` stored in the session storage
  # has precedence to allow admin logins.
  #
  # @param [String] auth the authorization token
  # @param [Object] headers the tracking headers
  #
  start: (auth, headers) ->
    @token = localStorage['auth_token'] || sessionStorage['auth_token'] || auth

    if @isAuthenticated()
      @authenticateAPI()
      @loginUser()

    $.ajaxSetup
      global: true
      cache: !sessionStorage['xhr_caching'] || sessionStorage['xhr_caching'] == 'true'

    $.ajaxSetup(headers: headers) if headers

    App.start()

    try
      Backbone.history.start(pushState: true)

  # Handle the default (empty) route.
  #
  handleDefaultRoute: ->
    @homeTriage()

  # Handle the fallback route that isn't handled by any controller.
  #
  # @param [String] url The URL that was not matched by any other route
  #
  handleFallbackRoute: (url) ->
    Backbone.history.navigate '/error/404', true

  handleNopRouter: ->

  # Simple integration test helper to set the user credentials
  # and not showing any content (e.g. Dashboard) or making any
  # request to speed up tests.
  #
  # This is necessary because Selenium needs to open a valid page
  # on the testing domain, so that we can use the session storage.
  #
  # @param [String] id the user us
  # @param [String] token the authentication token
  #
  loginIntegrationSpec: (id, token) ->
    sessionStorage['auth_id'] = id
    sessionStorage['auth_token'] = token
    @setLocale 'en'
    $('#container').text('Login credentials for the integration spec saved.')

  # Triage for the root route.
  #
  homeTriage: ->
    Backbone.history.navigate '/timelet', true

  # Sets the application language. If no language is supplied,
  # then the session locale or the HTML document language is taken.
  #
  # The language selection is persisted for the browser session.
  #
  # @param [String] locale the new locale to use
  #
  setLocale: (lang) ->
    locale = lang || sessionStorage['language'] || $('html').attr('lang')

    if @isValidLocale locale

      I18n.locale = locale
      moment.lang locale
      sessionStorage['language'] = locale

      $.ajaxSetup
        headers:
          'Accept-Language': locale

    App.trigger 'change:locale', locale if lang

  # Validates a given locale string.
  #
  # @param [String] locale The locale to validate
  # @return true if the locale is valid
  #
  isValidLocale: (locale) ->
    _.include ['en', 'de'], locale

  # Changes the default locale and gracefully reloads the
  # current page.
  #
  # @param [String] locale Locale abbreviation (e.g 'en' or 'de')
  #
  switchLocale: (locale) ->
    fragment = Backbone.history.getFragment()
    currentLocale = fragment.split('/')[0]

    if @isValidLocale currentLocale
      fragment = fragment.split('/').slice(1).join('/')

    Backbone.history.navigate "#{ locale }/#{ fragment }", { trigger: false, replace: false }
    $('body').fadeOut 200, @reload

  # Set the HTTP Authorization token if available
  #
  authenticateAPI: ->
    $.ajaxSetup
      headers:
        'Auth-Token': @token
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  # Checks if the user is authenticated
  #
  # @return [Boolean] the authentication status
  #
  isAuthenticated: ->
    not _.isEmpty @token

  # Get the authenticated user. This returns a promise
  # that either will be resolved or rejected.
  #
  # @return [jQuery.Promise] the user login promise
  #
  loginUser: ->
    if @loginUserDeferred
      @loginUserDeferred.promise()

    else
      @loginUserDeferred = new $.Deferred()

      if @token
        new Recomy.Models.User().fetch({
          notify: false
          url: '/api/user/authentication'
          error: =>
            @logout()
            @loginUserDeferred.reject()

          success: (user) =>
            @login(user)
            @loginUserDeferred.resolve(user)
        })

        @loginUserDeferred.promise()

      else
        @loginUserDeferred.reject()
        @loginUserDeferred.promise()

  # Login the user by remembering auth stuff for the
  # session, or if remember is true, in the local
  # storage until log out.
  #
  # The logged in user is stored as Recomy.application.currentUser.
  #
  # The redirection is either a boolean flag that indicates whether the
  # user should be redirected by the default triage, or if it's a string,
  # the custom redirect location after login.
  #
  # @param [Recomy.Models.User] user the user to log in
  # @param [Boolean] remember whether the user should be remembered
  # @param [Boolean, String] redirect the user after login
  #
  login: (user, remember = false, redirect = false) ->
    @token = user.get 'authentication_token'
    @currentUser = user

    debuggify?.alias "[#{ user.id }]#{ if user.get('email') then ' ' + user.get('email') else '' }"

    if @loginUserDeferred is undefined or @loginUserDeferred.state() is 'rejected'
      @loginUserDeferred = new $.Deferred()
      @loginUserDeferred.resolve(user)

    @setLocale user.get 'language'
    @authenticateAPI()

    if remember
      localStorage['auth_token'] = @token
    else
      sessionStorage['auth_token'] = @token

    App.trigger 'login:user'

    # Default user redirection after login
    #
    if redirect
      if _.isString redirect
        Backbone.history.navigate redirect, true
      else
        if user.isAmbassador()
          Backbone.history.navigate '/monetize', true
        else if user.isProUser()
          Backbone.history.navigate '/manage', true
        else
          Backbone.history.navigate '/dashboard', true

  # Logout the user from the Recomy application by removing
  # any stored authenticated related stuff.
  #
  # This also informs the server, since the backend keeps track
  # of a user session which has to be deleted.
  #
  # @param [Boolean] redirect redirect to homepage after logout
  #
  logout: (redirect) ->
    $.ajax '/api/user/authentication',
      type: 'DELETE'

      error: ->
        Recomy.collections.notifications().uniqueAdd
          message: I18n.t('frontend.messages.error_logout')
          type: 'error'

      success: =>
        delete @currentUser
        delete @token
        delete @loginUserDeferred

        localStorage.removeItem 'auth_token'
        sessionStorage.removeItem 'auth_token'

        debuggify?.alias 'anonymous'

        Backbone.history.navigate('/jobs', true) if redirect

        Recomy.collections.notifications().uniqueAdd
          message: I18n.t('frontend.messages.successful_logout')
          type: 'success'

        App.trigger 'logout:user'

  # Sets the Marionette renderer to the custome Recomy renderer
  #
  setRenderer: ->
    Backbone.Marionette.Renderer.render = @renderTemplate

  # Catch all relative `/` links within the document to
  # navigate directly in the Backbone application.
  #
  enablePushStateNavigation: ->
    $(document).delegate 'a:not(".external")', 'click', (event) ->
      target = $(@).attr('href')

      # List links that are NOT captured (http://,https://,#,mailto:,javascript and empty)
      unless /(^(https?:\/\/|\/\/|#|mailto:|javascript:|$))/.test(target or '')
        event.preventDefault()
        Backbone.history.navigate target, true
        App.trigger 'change:route', target

  # Renders a Haml Coffee Assets template
  #
  renderTemplate: (template, data) ->
    if JST[template]
      JST[template](data)
    else if _.isFunction(template)
      template(data)
    else
      console.error 'Template %s not found', template

  # Extend each template context object.
  #
  # @param [Object] locals the local context data
  # @return [Object] the global context
  #
  globalTemplateContext: (locals = {}) ->
    _.extend({}, {
      currentUser: @currentUser
    }, locals)

  # Shows a user notification.
  #
  # @param [String] message the message to show
  # @param [String] type the notification type
  #
  notify: (message, type = 'success') ->
    Recomy.collections.notifications().uniqueAdd
      message: message
      type: type

  # Reload the application
  #
  reload: ->
    window.location.reload()

  # Navigate back in the history
  #
  back: ->
    window.history.back()
