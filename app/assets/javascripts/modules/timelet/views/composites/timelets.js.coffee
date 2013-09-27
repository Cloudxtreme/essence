# Composite view of timelets.
#
# Manages a single timelet in @model and a collection of timelets
# in @collection.
#
# The @model will render as a clock, running a single timelet.
#
# The @collection will render as an index of timelets which can be
# loaded into the clock.
#
class Essence.Views.Timelets extends Backbone.Marionette.CompositeView

  template: 'modules/timelet/templates/timelets'

  itemView: Essence.Views.Timelet
  itemViewContainer: 'section.timelets ul'

  emptyView: Essence.Views.NoTimelet

  initialize: ->
    @listenTo @collection, 'sync', @render
    @listenTo @model, 'sync', @render

    @listenTo @model, 'change:timer', @renderTimer
    @listenTo @model, 'change:running', @renderPlayButton

    @on 'itemview:timelet:load', (itemView) =>
      @loadTimelet itemView.model

  ui:
    clockTitle: 'section.clock .name'
    clockSave:  'section.clock .save'
    clockTimer: 'section.clock .time'
    clockStart: 'section.clock .play'

  events:
    'click section.clock .play':   'playTimelet'
    'blur  section.clock .time':   'updateDuration'
    'blur  section.clock .name':   'updateName'
    'click section.clock .save':   'saveTimelet'
    'click section.timelets .add': 'createTimelet'

  # Loads a timelet from the collection
  #
  # @param [Backbone.Model] timelet The timelet to load
  #
  loadTimelet: (timelet) ->
    @stopTimelet()
    @model.set timelet.attributes, silent: true
    @model.set
      timer: @model.get('duration')
      running: false
    ,
      silent: true
    @render()

  # Starts or pauses the current timer.
  #
  # Does nothing if the timer is not valid.
  #
  # @param [jQuery.Event] event the click event
  #
  playTimelet: (event) =>
    if @model.get('running')
      @stopTimelet()
    else
      @startTimelet()

  # Starts the current timer.
  #
  startTimelet: ->
    return unless @model.isValid()

    @ui.clockTimer.removeAttr 'contentEditable'
    @model.set running: true
    @running = setInterval @tick, 1000

  # Stops the current timer.
  #
  stopTimelet: ->
    clearInterval @running
    delete @running

    @model.set running: false
    @ui.clockTimer.attr 'contentEditable', 'true'

  # Decrements the timer value by one.
  #
  tick: =>
    @model.set timer: (@model.get('timer') - 1)
    @stopTimelet() unless @model.isValid()

  # Saves the timelet to the collection.
  #
  # @param [jQuery.Event] event the click event
  #
  saveTimelet: (event) =>
    @collection.add @model, merge: true
    @model.save()
    @render()

  # Creates a new model of a timelet.
  #
  # First saves any changes to the current model.
  #
  # @param [jQuery.Event] event the click event
  #
  createTimelet: (event) =>
    @model.save()
    @model = new Essence.Models.Timelet
    Backbone.history.navigate '/timelet'
    @render()

  # Stores the name of the timelet
  #
  # @param [jQuery.Event] event the click event
  #
  updateName: (event) =>
    @model.set name: @ui.clockTitle.text()
    if @model.hasChanged('name')
      @ui.clockSave.fadeIn()

  # Stores the duration of the timelet
  #
  # @param [jQuery.Event] event the click event
  #
  updateDuration: (event) =>
    if duration = parseInt @ui.clockTimer.text()
      @model.set
        duration: duration
        timer: duration
    @ui.clockSave.fadeIn() if @model.hasChanged('duration')

  # Render the current timer value.
  #
  renderTimer: =>
    @ui.clockTimer.text @model.get('timer')

  # Render the play button depending on the status of the timelet.
  #
  renderPlayButton: =>
    @ui.clockStart.text if @model.get('running') then '\uF04C' else '\uF04B'
