# Model for a Timelet
#
class Essence.Models.Timelet extends Backbone.Model
  localStorage: new Backbone.LocalStorage 'Timelets'

  defaults:
    loaded: false
    name: 'New timelet'
    running: false
    duration: 0
    timer: '--'

  validate: (attrs, options) ->
    unless parseInt(attrs.timer) > 0
      return { timer: 'too small' }
    unless parseInt(attrs.duration)
      return { duration: 'invalid' }
    unless parseInt(attrs.duration) > 0
      return { duration: 'too small' }

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

  # Checks if the timelet loaded.
  #
  # @return [Boolean] `true` if the timelet is loaded, otherwise `false`
  #
  isLoaded: -> @get('loaded')

  # Decrements the timer value by one until it reaches zero.
  #
  tick: =>
    @set timer: (@get('timer') - 1)
    @stop() if @isFinished()

  # Loads a timer.
  #
  load: ->
    @collection.unload()
    @set { timer: @get('duration'), running: false }, { silent: true }
    @set loaded: true

  # Marks the timelet as not loaded.
  #
  unload: -> @set loaded: false

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

  # TODO refactor this into an Essence.Model
  #
  setStrict: (attribute, value) ->
    value = parseInt(value) if typeof @defaults[attribute] is 'number'
    @set attribute, value
