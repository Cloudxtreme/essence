# View of a clock running a timelet.
#
class Essence.Views.Clock extends Backbone.Marionette.ItemView

  template: 'modules/timelet/templates/clock'

  initialize: ->
    @listenTo @model, 'sync', @render

    @listenTo @model, 'change:timer', @renderTimer
    @listenTo @model, 'change:running', @renderPlayButton

  ui:
    timer:      '.timer'
    clockTitle: '.name'
    clockSave:  '.save'
    clockTimer: '.time'
    clockStart: '.play'

  events:
    'click .play': 'playTimelet'
    'blur  .time': 'updateDuration'
    'blur  .name': 'updateName'
    'click .save': 'saveTimelet'

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
    @runner = setInterval @tick, 1000

  # Stops the current timer.
  #
  stopTimelet: ->
    clearInterval @runner
    delete @runner

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
    @model.collection.add @model, merge: true
    @model.save()
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
    @ui.timer.toggleClass 'running', @model.get('running')
