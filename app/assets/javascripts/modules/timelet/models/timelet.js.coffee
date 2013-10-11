# Model for a Timelet
#
class Essence.Models.Timelet extends Essence.Model
  localStorage: new Backbone.LocalStorage 'Timelets'

  defaults:
    name: ''
    duration: 0
    loop: false
    alert: false

  validate: (attrs, options) ->
    unless parseInt(attrs.duration)
      return { duration: 'invalid' }
    unless parseInt(attrs.duration) > 0
      return { duration: 'too small' }

  initialize: ->
    # Define the non-persistant state of the Timelet.
    @state =
      timer: 0
      running: false
      loaded: false

  # Checks if the timer is running.
  #
  # @return [Boolean] `true` if the timer is running, otherwise `false`
  #
  isRunning: -> @state.running

  # Checks if the timer reached zero.
  #
  # @return [Boolean] `true` if the timer is finished, otherwise `false`
  #
  isFinished: -> @state.timer < 1

  # Checks if the timelet loaded.
  #
  # @return [Boolean] `true` if the timelet is loaded, otherwise `false`
  #
  isLoaded: -> @state.loaded

  # Checks if the timelet should alert.
  #
  # Evaluates to `true` when 10% of the duration is left and
  # the `alert` flag is set.
  #
  # @return [Boolean] `true` if the timelet can alert, otherwise `false`
  #
  isAlertable: ->
    @get('alert') and (@state.timer <= @get('duration') / 10.0)

  # Decrements the timer value by one until it reaches zero.
  #
  tick: =>
    @state.timer--

    @trigger 'tick'
    @trigger 'alert' if @isAlertable()

    if @isFinished()
      if @get('loop') then @restart() else @stop()

  # Loads a timer.
  #
  load: ->
    @collection.unload()
    @state.timer = @get 'duration'
    @state.loaded = true
    @state.running = false
    @trigger 'loaded'

  # Marks the timelet as not loaded.
  #
  unload: ->
    @state.loaded = false
    @trigger 'unloaded'

  # Starts the timer.
  #
  start: ->
    return unless @isValid()
    return if @isRunning()
    return if @isFinished()

    @state.running = true
    @runner = setInterval @tick, 1000
    @trigger 'start'

  # Stops the timer.
  #
  stop: ->
    clearInterval @runner
    delete @runner

    @state.running = false
    @trigger 'stop'

  # Pauses or starts the timer.
  #
  pause: ->
    if @isRunning() then @stop() else @start()

  # Restarts the timer.
  #
  restart: ->
    @state.timer = @get 'duration'
    if @isRunning()
      @stop()
      @start()
    else
      @stop()
