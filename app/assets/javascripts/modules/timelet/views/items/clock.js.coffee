# View of a clock running a timelet.
#
class Essence.Views.Clock extends Backbone.Marionette.ItemView

  template: 'modules/timelet/templates/clock'

  initialize: ->
    @listenTo @model, 'sync', @render

    @listenTo @model, 'change:timer', @renderTimer
    @listenTo @model, 'change:running', @renderPlayButton
    @listenTo @model, 'change:running', @toggleTimerEditability

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

  # Restarts the current timer.
  #
  restartTimelet: -> @model.restart()

  # Starts the current timer.
  #
  startTimelet: -> @model.start()

  # Stops the current timer.
  #
  stopTimelet: -> @model.stop()

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
    @$el.toggleClass 'running', @model.get('running')

  # Allow the timer field to be edited only when the Timelet is
  # not running.
  #
  # @param [Backbone.Model] model Model of the timelet
  # @param [Boolean] running flag indicating if the timer is running
  #
  toggleTimerEditability: (model, running) =>
    if running
      @ui.clockTimer.removeAttr 'contentEditable'
    else
      @ui.clockTimer.attr 'contentEditable', 'true'
