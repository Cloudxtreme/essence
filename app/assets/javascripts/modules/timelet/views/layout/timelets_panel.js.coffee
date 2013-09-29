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

    # FIXME this should be refactored as a model method.
    @model.set
      timer: @model.get('duration')
      running: false
    ,
      silent: true

    @clock.show new Essence.Views.Clock model: @model, parent: @

  # Creates a new model of a timelet.
  #
  # First saves any changes to the current model.
  #
  createTimelet: =>
    @model = new Essence.Models.Timelet {}, collection: @collection

    @clock.currentView.model.save()
    @clock.show new Essence.Views.Clock model: @model, parent: @
