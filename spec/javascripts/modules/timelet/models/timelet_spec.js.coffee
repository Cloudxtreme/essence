describe 'Essence.Models.Timelet', ->
  beforeEach ->
    @model = new Essence.Models.Timelet

  describe '#constructor', ->
    it 'creates a Backbone model', ->
      expect(@model).toBeAnInstanceOf Backbone.Model

  describe '#initialize', ->
    it 'defines the default state of a Timelet', ->
      expect(@model.state.timer).toEqual 0
      expect(@model.state.running).toBeFalsy()
      expect(@model.state.loaded).toBeFalsy()

  describe '#fetch', ->
    it 'loads the model from localStorage', ->
      spy = sinon.spy Backbone, 'localSync'
      @model.set id: 1
      @model.fetch()
      expect(spy).toHaveBeenCalled()
      spy.restore()

  describe '#validate', ->
    it 'succeeds with valid attributes', ->
      @model.set duration: 40
      expect(@model.isValid()).toBeTruthy()

    it 'fails without a duration', ->
      expect(@model.isValid()).toBeFalsy()

    it 'fails with an invalid duration', ->
      @model.set duration: 'abc'
      expect(@model.isValid()).toBeFalsy()

    it 'fails with a too small duration', ->
      @model.set duration: 0
      expect(@model.isValid()).toBeFalsy()

  describe '#isRunning', ->
    describe 'with a running timer', ->
      beforeEach ->
        @model.state.running = true

      it 'returns true', ->
        expect(@model.isRunning()).toBeTruthy()

    describe 'with a stopped timer', ->
      beforeEach ->
        @model.state.running = false

      it 'returns true', ->
        expect(@model.isRunning()).toBeFalsy()

  describe '#isFinished', ->
    describe 'with an unfinished timer', ->
      beforeEach ->
        @model.state.timer = 1

      it 'returns true', ->
        expect(@model.isFinished()).toBeFalsy()

    describe 'with timer that ran out', ->
      beforeEach ->
        @model.state.timer = 0

      it 'returns true', ->
        expect(@model.isFinished()).toBeTruthy()

  describe '#isLoaded', ->
    describe 'with a loaded timelet', ->
      beforeEach ->
        @model.state.loaded = true

      it 'returns true', ->
        expect(@model.isLoaded()).toBeTruthy()

    describe 'with an unloaded timelet', ->
      beforeEach ->
        @model.state.loaded = false

      it 'returns true', ->
        expect(@model.isLoaded()).toBeFalsy()

  describe '#tick', ->
    it 'decrements the timer', ->
      @model.state.timer = 42
      @model.tick()
      expect(@model.state.timer).toEqual 41

    it 'triggers the tick event', ->
      spy = sinon.spy @model, 'trigger'
      @model.tick()
      expect(spy).toHaveBeenCalledWith 'tick'
      spy.restore()

    describe 'when the timer reached 0', ->
      beforeEach ->
        @model.state.timer = 0

      it 'stops the timelet', ->
        spy = sinon.spy @model, 'stop'
        @model.tick()
        expect(spy).toHaveBeenCalled()

  describe '#load', ->
    beforeEach ->
      @model.set duration: 79
      @model.state.timer = 40
      @model.state.running = false
      @model.state.loaded = false
      @otherTimelet = new Essence.Models.Timelet
      @model.collection = new Essence.Collections.Timelets [@otherTimelet, @model]

    it 'rewinds the timelet in case it was already running', ->
      @model.load()
      expect(@model.state.timer).toEqual 79
      expect(@model.isRunning()).toBeFalsy()
      expect(@model.isLoaded()).toBeTruthy()

    it 'unloads all other timelets', ->
      @model.load()
      expect(@model.isLoaded()).toBeTruthy()
      expect(@otherTimelet.isLoaded()).toBeFalsy()

    it 'triggers the load event', ->
      spy = sinon.spy @model, 'trigger'
      @model.load()
      expect(spy).toHaveBeenCalledWith 'loaded'
      spy.restore()

  describe '#unload', ->
    beforeEach ->
      @model.state.loaded = true

    it 'marks the timelet as not loaded', ->
      @model.unload()
      expect(@model.isLoaded()).toBeFalsy()

    it 'triggers the unload event', ->
      spy = sinon.spy @model, 'trigger'
      @model.unload()
      expect(spy).toHaveBeenCalledWith 'unloaded'
      spy.restore()
        
  describe '#start', ->
    beforeEach ->
      @model.set duration: 30
      @model.state.running = false
      @model.state.timer = 10

    describe 'with a finished timer', ->
      beforeEach ->
        @model.state.timer = 0

      it 'does nothing', ->
        @model.start()
        expect(@model.runner).toBeUndefined()

    describe 'with a running timer', ->
      beforeEach ->
        @model.state.running = true

      it 'does nothing', ->
        @model.start()
        expect(@model.runner).toBeUndefined()

    describe 'with a valid timer', ->
      it 'starts the timer', ->
        @model.start()
        expect(@model.runner).toBeDefined()

      it 'triggers the start event', ->
        spy = sinon.spy @model, 'trigger'
        @model.start()
        expect(spy).toHaveBeenCalledWith 'start'
        spy.restore()

      it 'sets the running state', ->
        @model.start()
        expect(@model.isRunning()).toBeTruthy()

  describe '#stop', ->
    beforeEach ->
      @model.state.running = true

    it 'stops the countdown', ->
      @model.runner = 123
      @model.stop()
      expect(@model.runner).toBeUndefined()

    it 'triggers the stop event', ->
      spy = sinon.spy @model, 'trigger'
      @model.stop()
      expect(spy).toHaveBeenCalledWith 'stop'
      spy.restore()

    it 'sets the running state', ->
      @model.stop()
      expect(@model.isRunning()).toBeFalsy()

  describe '#pause', ->
    describe 'when running', ->
      beforeEach ->
        @model.state.running = true

      it 'stops the timer', ->
        spy = sinon.spy @model, 'stop'
        @model.pause()
        expect(spy).toHaveBeenCalled()
        spy.restore()

    describe 'when stopped', ->
      beforeEach ->
        @model.state.running = false

      it 'starts the timer', ->
        spy = sinon.spy @model, 'start'
        @model.pause()
        expect(spy).toHaveBeenCalled()
        spy.restore()

  describe '#restart', ->
    describe 'when finished', ->
      beforeEach ->
        @model.set duration: 32
        @model.state.timer = 0
        @model.state.running = false

      it 'restores the timer', ->
        expect(@model.state.timer).toEqual 0
        @model.restart()
        expect(@model.state.timer).toEqual 32

      it 'does not start the timer', ->
        expect(@model.isRunning()).toBeFalsy()
        @model.restart()
        expect(@model.isRunning()).toBeFalsy()
        expect(@model.runner).toBeUndefined()

    describe 'with an invalid duration', ->
      beforeEach ->
        @model.set duration: 'abc'
        @model.state.timer = 10

      it 'restores the timer', ->
        expect(@model.state.timer).toEqual 10
        @model.restart()
        expect(@model.state.timer).toEqual 'abc'

      it 'does nothing', ->
        @model.restart()
        expect(@model.runner).toBeUndefined()

    describe 'when paused', ->
      beforeEach ->
        @model.set duration: 28
        @model.state.timer = 17
        @model.state.running = false

      it 'restores the timer', ->
        expect(@model.state.timer).toEqual 17
        @model.restart()
        expect(@model.state.timer).toEqual 28

      it 'does not start the timer', ->
        expect(@model.isRunning()).toBeFalsy()
        @model.restart()
        expect(@model.isRunning()).toBeFalsy()
        expect(@model.runner).toBeUndefined()

    describe 'when running', ->
      beforeEach ->
        @model.set duration: 67
        @model.state.timer = 13
        @model.state.running = true

      it 'restores the timer', ->
        expect(@model.state.timer).toEqual 13
        @model.restart()
        expect(@model.state.timer).toEqual 67

      it 'does not stop the timer', ->
        expect(@model.isRunning()).toBeTruthy()
        @model.restart()
        expect(@model.isRunning()).toBeTruthy()
        expect(@model.runner).toBeDefined()
