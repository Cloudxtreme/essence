# A single clock view.
#
class Essence.Views.Clock extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/clock'

  ui:
    clock:     'section.clock'
    countdown: 'section.countdown'
    timer:     'section.countdown .timer'
    controls:  'section.controls'
    duration:  'section.clock input.duration'

  events:
    'click .start':     'startTimer'
    'change .duration': 'updateDuration'

  initialize: ->
    @listenTo @model, 'change:timer', @renderTimer

  # Starts a timer with the value stored in the model.
  #
  # @param [jQuery.Event] event the click event
  #
  startTimer: (event) =>
    @model.set timer: @model.get('duration')

    # Stop a previous timer if any
    clearInterval @timer if @timer

    @ui.countdown.slideDown()
    @timer = setInterval @tick, 1000

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
