# The Timlets Marionette module definition.
#
#= require_directory ./templates
#= require_directory ./models
#= require_directory ./collections
#= require_directory ./views/items
#= require_directory ./views/collections
#= require_directory ./views/layout
#
class Essence.Timelet extends Essence.Controller

  # Create the  HTML structure and
  # named regions for view management.
  #
  class @Layout extends Backbone.Marionette.Layout
    template: 'timelet/layout'

    regions:
      header:        'header'
      navigations:   'section.navigations'
      notifications: 'section.notifications'
      dashboard:     'article.dashboard'
      payOut:        'article.payout'
      footer:        'footer'

    # Add module CSS context
    #
    onRender: ->
      @$el.addClass 'timelet'

    # Remove module CSS context
    #
    onClose: ->
      @$el.removeClass 'timelet'

  # Defines the url routes the module will handle.
  #
  class @Router extends Backbone.Marionette.AppRouter
    appRoutes:
      'timelet': 'dashboard'

  # Start the routing
  #
  constructor: ->
    new Essence.Timelet.Router(controller: @)

  # Setup the module layout
  #
  setup: ->
    @layout = new Essence.Timelet.Layout()
    App.container.show @layout

    # TODO
    #@layout.header.show new Essence.Views.Header()
    #@layout.notifications.show new Essence.Views.Notifications()
    #@layout.footer.show new Essence.Views.Footer()

  # Shows the timelets dashboard.
  #
  dashboard: ->
    @setup()

    @layout.dashboard.show new Essence.Views.TimeletDashboard
