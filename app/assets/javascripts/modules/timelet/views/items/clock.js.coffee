# A single clock view.
#
class Essence.Views.Clock extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/clock'
  className: 'timelet'
  tagName: 'section'

  ui:
    title: 'div.title .name'
    save:  'div.title .save'
    timer: 'div.timer .time'
    start: 'div.timer .play'

  events:
    'click div.timer .play': 'playTimelet'
    'blur  div.timer .time': 'updateDuration'
    'blur  div.title .name': 'updateName'
    'click div.title .save': 'save'

  initialize: ->
    @model.set running: false
    @listenTo @model, 'change:timer', @renderTimer
    @listenTo @model, 'change:running', @renderPlayButton
    @listenTo @model, 'sync', @render

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

    @ui.timer.removeAttr 'contentEditable'
    @model.set running: true
    @running = setInterval @tick, 1000

  # Stops the current timer.
  #
  stopTimelet: ->
    clearInterval @running
    delete @running

    @model.set running: false
    @ui.timer.attr 'contentEditable', 'true'

  # Decrements the timer value by one.
  #
  tick: =>
    @model.set timer: (@model.get('timer') - 1)
    @stopTimelet() unless @model.isValid()

  # Saves the timelet to the collection.
  #
  # @param [jQuery.Event] event the click event
  #
  save: (event) =>
    @collection.add @model, merge: true
    @model.save()

  # Stores the name of the timelet
  #
  # @param [jQuery.Event] event the click event
  #
  updateName: (event) =>
    @model.set name: @ui.title.text()
    if @model.hasChanged('name')
      @ui.save.fadeIn()

  # Stores the duration of the timelet
  #
  # @param [jQuery.Event] event the click event
  #
  updateDuration: (event) =>
    if duration = parseInt @ui.timer.text()
      @model.set
        duration: duration
        timer: duration
    @ui.save.fadeIn() if @model.hasChanged('duration')

  # Render the current timer value.
  #
  renderTimer: =>
    @ui.timer.text @model.get('timer')

  # Render the play button depending on the status of the timelet.
  #
  renderPlayButton: =>
    @ui.start.text if @model.get('running') then '\uF04C' else '\uF04B'
