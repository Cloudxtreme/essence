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
    start: 'div.timer .start'

  events:
    'click  div.timer .start': 'startTimer'
    'change div.timer span':   'updateDuration'
    'focus  div.title span':   'startEditName'
    'blur   div.title span':   'stopEditName'

  initialize: ->
    @model.set timer: @model.get('duration')
    @listenTo @model, 'change:timer', @renderTimer

  # Starts a timer with the value stored in the model.
  #
  # @param [jQuery.Event] event the click event
  #
  startTimer: (event) =>
    @model.set timer: @model.get('duration')

    # Stop a previous timer if any
    clearInterval @timer if @timer

    @timer = setInterval @tick, 1000

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
