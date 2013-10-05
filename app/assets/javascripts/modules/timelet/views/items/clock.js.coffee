# View of a clock running a timelet.
#
class Essence.Views.Clock extends Backbone.Marionette.ItemView

  template: 'modules/timelet/templates/clock'

  initialize: ->
    @listenTo @model, 'sync', @render

    @listenTo @model, 'tick',  @renderTimer
    @listenTo @model, 'start', @applyRunningState
    @listenTo @model, 'stop',  @applyRunningState

  ui:
    timer:      '.timer'
    clockTitle: '.name'
    clockSave:  '.save'
    clockTimer: '.time'
    clockStart: '.play'

  events:
    'click .play':  'pauseTimelet'
    'click .reset': 'restartTimelet'

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

  # Render the current timer value.
  #
  renderTimer: =>
    @ui.clockTimer.text @model.state.timer

  # Marks the clock as running if applicable.
  #
  applyRunningState: =>
    @$el.toggleClass 'running', @model.isRunning()
