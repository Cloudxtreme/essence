# Model for a Timelet
#
class Essence.Models.Timelet extends Backbone.Model
  localStorage: new Backbone.LocalStorage 'Timelets'

  defaults:
    name: 'New timelet'
    running: false
    duration: 0
    timer: '--'

  validate: (attrs, options) ->
    unless parseInt(attrs.timer) > 0
      return 'Timer is too small'
    unless parseInt(attrs.duration)
      return 'Invalid duration'
    unless parseInt(attrs.duration) > 0
      return 'Duration is too small'

  # Checks if the timer is running.
  #
  # @return [Boolean] `true` if the timer is running, otherwise `false`
  #
  isRunning: -> @get 'running'

  # Checks if the timer reached zero.
  #
  # @return [Boolean] `true` if the timer is finished, otherwise `false`
  #
  isFinished: -> @get('timer') < 1

  # Decrements the timer value by one until it reaches zero.
  #
  tick: =>
    @set timer: (@get('timer') - 1)
    @stop() if @isFinished()

  # Starts the timer.
  #
  start: ->
    return unless @isValid()
    return if @isRunning()

    @set running: true
    @runner = setInterval @tick, 1000

  # Stops the timer.
  #
  stop: ->
    clearInterval @runner
    delete @runner

    @set running: false

  # Pauses or starts the timer.
  #
  pause: ->
    if @isRunning() then @stop() else @start()

  # Restarts the timer.
  #
  restart: ->
    @set timer: @get('duration')
    if @isRunning()
      @stop()
      @start()
    else
      @stop()
