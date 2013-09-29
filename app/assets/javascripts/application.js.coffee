#= require i18n
#= require jquery
#= require jquery_ujs
#= require underscore
#= require moment
#= require hamlcoffee
#= require backbone
#= require backbone.marionette
#= require backbone/backbone.localstorage.js
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
class Essence.Application

  # Defines the url routes the base app will handle.
  #
  class @Router extends Backbone.Marionette.AppRouter
    appRoutes:
      ''                 : 'handleDefaultRoute'

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
  start: ->
    App.start()

    try
      Backbone.history.start(pushState: true)

  # Handle the default (empty) route.
  #
  handleDefaultRoute: ->
    Backbone.history.navigate '/timelet', true

  # Handle the fallback route that isn't handled by any controller.
  #
  # @param [String] url The URL that was not matched by any other route
  #
  handleFallbackRoute: (url) ->

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

  # Sets the Marionette renderer to a custom renderer.
  #
  setRenderer: ->
    Backbone.Marionette.Renderer.render = @renderTemplate

  # Catch all relative `/` links within the document to
  # navigate directly in the Backbone application.
  #
  enablePushStateNavigation: ->
    $(document).delegate 'a:not(".external")', 'click', (event) ->
      target = $(@).attr('href')

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

  # Reload the application
  #
  reload: ->
    window.location.reload()

  # Navigate back in the history
  #
  back: ->
    window.history.back()
