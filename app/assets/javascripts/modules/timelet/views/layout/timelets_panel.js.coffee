# Mediator between the timelets collection and the clock.
#
# Manages a single timelet model in a clock view.
#
# Manages all timlets in a timelet list.
#
class Essence.Views.TimeletsPanel extends Backbone.Marionette.Layout

  template: 'modules/timelet/templates/timelets_panel'

  regions:
    clock:    'section.clock'
    timelets: 'section.timelets'

  initialize: ->
    @on 'timelet:load', @loadTimelet
    @on 'timelet:create', @createTimelet

    # FIXME
    # This looks like a racing condition waiting to happen.
    # If the @model syncs first, the @collection sync callback
    # will override the loading of the @model.
    #
    # Solutions:
    # * Use promises to sync the model after the collection.
    # * Use promises to load the model when both the model and
    #   the collection have been synced.
    # * Don't fetch the model at all, but pick it from the
    #   collection once it's synced.
    #
    @listenTo @collection, 'sync', =>
      @collection.unload()

    # A restored Timelet should be reflected in the collection.
    #
    @listenTo @model, 'sync', =>
      @collection.get(@model)?.load()

  onRender: ->
    @clock.show new Essence.Views.Clock model: @model, parent: @
    @timelets.show new Essence.Views.Timelets collection: @collection, parent: @

  # Loads a timelet from the collection
  #
  # @param [String] id The ID of the model to load
  #
  loadTimelet: (id) =>
    @clock.currentView.stopTimelet()
    @model = @collection.get id

    @model.load()

    @clock.show new Essence.Views.Clock model: @model, parent: @

  # Creates a new model of a timelet.
  #
  # First saves any changes to the current model.
  #
  createTimelet: =>
    @model = new Essence.Models.Timelet {}, collection: @collection

    @clock.currentView.model.save()
    @clock.show new Essence.Views.Clock model: @model, parent: @
    @model.load()
