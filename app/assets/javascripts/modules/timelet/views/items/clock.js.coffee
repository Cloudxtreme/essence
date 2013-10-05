# View of a clock running a timelet.
#
class Essence.Views.Clock extends Backbone.Marionette.ItemView

  template: 'modules/timelet/templates/clock'

  initialize: ->
    @listenTo @model, 'sync', @render

    @listenTo @model, 'tick',  @renderTimer
    @listenTo @model, 'start', @applyRunningState
    @listenTo @model, 'stop',  @applyRunningState
    @listenTo @model, 'start', @toggleTimerEditability
    @listenTo @model, 'stop',  @toggleTimerEditability

  ui:
    timer:      '.timer'
    clockTitle: '.name'
    clockSave:  '.save'
    clockTimer: '.time'
    clockStart: '.play'

  events:
    'click .play':  'pauseTimelet'
    'click .reset': 'restartTimelet'
    'blur  .time':  'updateDuration'
    'blur  .name':  'updateName'
    'click .save':  'saveTimelet'

  # Starts or pauses the current timer.
  #
  pauseTimelet: -> @model.pause()

  # Starts the current timer.
  #
  startTimelet: -> @model.start()

  # Stops the current timer.
  #
  stopTimelet: -> @model.stop()

  # Restarts the current timer.
  #
  restartTimelet: ->
    @model.restart()
    @renderTimer()

  # Saves the timelet to the collection.
  #
  # @param [jQuery.Event] event the click event
  #
  saveTimelet: (event) =>
    @model.collection.add @model, merge: true
    @model.save()
    @render()
    Backbone.history.navigate "/timelet/#{ @model.id }"

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
      @model.set duration: duration
    @ui.clockSave.fadeIn() if @model.hasChanged('duration')

  # Render the current timer value.
  #
  renderTimer: =>
    @ui.clockTimer.text @model.state.timer

  # Marks the clock as running if applicable.
  #
  applyRunningState: =>
    @$el.toggleClass 'running', @model.isRunning()

  # Allow the timer field to be edited if it's running.
  #
  toggleTimerEditability: =>
    if @model.isRunning()
      @ui.clockTimer.removeAttr 'contentEditable'
    else
      @ui.clockTimer.attr 'contentEditable', 'true'
