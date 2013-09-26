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
    'click  div.timer .play':  'startTimer'
    'change div.timer .time':  'updateDuration'
    'focus  div.title .name':  'startEditName'
    'blur   div.title .name':  'stopEditName'

  initialize: ->
    @model.set timer: @model.get('duration')
    @listenTo @model, 'change:timer', @renderTimer
    @listenTo @model, 'change:running', @renderPlayButton

  # Starts or pauses a timer with the value stored in the model.
  #
  # @param [jQuery.Event] event the click event
  #
  startTimer: (event) =>
    if @running
      clearInterval @running
      delete @running
      @model.set 'running', false
    else
      @running = setInterval @tick, 1000
      @model.set 'running', true

  # Start editing the name of the timelet.
  #
  # @param [jQuery.Event] event the click event
  #
  startEditName: (event) =>
    @ui.save.fadeIn()

  # Stop editing the name of the timelet.
  #
  # @param [jQuery.Event] event the click event
  #
  stopEditName: (event) =>
    @ui.save.fadeOut()

  # Decrements the timer value by one.
  #
  tick: =>
    @model.set timer: (@model.get('timer') - 1)

  # Stores the duration of the timelet
  #
  # @param [jQuery.Event] event the click event
  #
  updateDuration: (event) =>
    @model.set duration: @ui.duration.val()

  # Render the current timer value
  #
  renderTimer: =>
    @ui.timer.text @model.get('timer')

  renderPlayButton: =>
    @ui.start.text if @running then '\uF04C' else '\uF04B'
