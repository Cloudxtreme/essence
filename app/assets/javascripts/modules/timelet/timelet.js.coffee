# The Timlets Marionette module definition.
#
#= require_directory ./templates
#= require_directory ./models
#= require_directory ./collections
#= require_directory ./views/items
#= require_directory ./views/collections
#= require_directory ./views/composites
#= require_directory ./views/layout
#
class Essence.Timelet

  # Create the  HTML structure and
  # named regions for view management.
  #
  class @Layout extends Backbone.Marionette.Layout
    template: 'modules/timelet/templates/layout'

    regions:
      header:        'header'
      navigations:   'section.navigations'
      timelets:      'article.timelets'
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
      'timelet/:id': 'showTimelets'
      'timelet':     'showTimelets'

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
    #@layout.footer.show new Essence.Views.Footer()

  # Renders both the clock and the timelets collection.
  #
  # Sets up the model and collection and fetches them
  # from the endpoint.
  #
  # @param [Integer] id ID of the timelet to load.
  #
  showTimelets: (id) ->
    @setup()

    collection = new Essence.Collections.Timelets
    model = new Essence.Models.Timelet { id: id }, collection: collection

    @layout.timelets.show new Essence.Views.TimeletsPanel model: model, collection: collection

    collection.fetch reset: true
