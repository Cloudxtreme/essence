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
    'click div.timer .play': 'startTimer'
    'blur  div.timer .time': 'updateDuration'
    'blur  div.title .name': 'updateName'
    'click div.title .save': 'save'

  initialize: ->
    @model.set timer: @model.get('duration')
    @listenTo @model, 'change:timer', @renderTimer
    @listenTo @model, 'change:running', @renderPlayButton

  # Starts or pauses a timer with the value stored in the model.
  #
  # @param [jQuery.Event] event the click event
  #
  startTimer: (event) =>
    # FIXME Move @running to @model
    if @running
      clearInterval @running
      delete @running
      @model.set 'running', false
      @ui.timer.attr 'contentEditable', 'true'
    else
      @running = setInterval @tick, 1000
      @model.set 'running', true
      @ui.timer.removeAttr 'contentEditable'

  # Decrements the timer value by one.
  #
  tick: =>
    @model.set timer: (@model.get('timer') - 1)

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
    @ui.save.fadeIn() if @model.hasChanged('name')

  # Stores the duration of the timelet
  #
  # @param [jQuery.Event] event the click event
  #
  updateDuration: (event) =>
    if duration = parseInt @ui.timer.text()
      @model.set duration: duration
    @ui.save.fadeIn() if @model.hasChanged('duration')

  # Render the current timer value.
  #
  renderTimer: =>
    @ui.timer.text @model.get('timer')

  # Render the play button depending on the status of the timelet.
  #
  renderPlayButton: =>
    @ui.start.text if @running then '\uF04C' else '\uF04B'
