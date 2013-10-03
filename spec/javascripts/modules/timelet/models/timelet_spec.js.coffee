describe 'Essence.Models.Timelet', ->
  beforeEach ->
    @model = new Essence.Models.Timelet

  describe '#constructor', ->
    it 'creates a Backbone model', ->
      expect(@model).toBeAnInstanceOf Backbone.Model

  describe '#fetch', ->
    it 'loads the model from localStorage', ->
      spy = sinon.spy Backbone, 'localSync'
      @model.set id: 1
      @model.fetch()
      expect(spy).toHaveBeenCalled()
      spy.restore()

  describe '#validate', ->
    it 'succeeds with valid attributes', ->
      @model.set timer: 23, duration: 40
      expect(@model.isValid()).toBeTruthy()

    it 'fails without a duration', ->
      @model.set timer: 23
      expect(@model.isValid()).toBeFalsy()

    it 'fails without a timer', ->
      @model.set duration: 23
      expect(@model.isValid()).toBeFalsy()

    it 'fails with an invalid timer', ->
      @model.set timer: 'abc', duration: 23
      expect(@model.isValid()).toBeFalsy()

    it 'fails with an invalid duration', ->
      @model.set timer: 23, duration: 'abc'
      expect(@model.isValid()).toBeFalsy()

    it 'fails with a too small duration', ->
      @model.set timer: 23, duration: 0
      expect(@model.isValid()).toBeFalsy()

    it 'fails with a timer that ran out', ->
      @model.set timer: 0, duration: 40
      expect(@model.isValid()).toBeFalsy()

  describe '#isRunning', ->
    describe 'with a running timer', ->
      beforeEach ->
        @model.set running: true

      it 'returns true', ->
        expect(@model.isRunning()).toBeTruthy()

    describe 'with a stopped timer', ->
      beforeEach ->
        @model.set running: false

      it 'returns true', ->
        expect(@model.isRunning()).toBeFalsy()

  describe '#isFinished', ->
    describe 'with an unfinished timer', ->
      beforeEach ->
        @model.set timer: 1

      it 'returns true', ->
        expect(@model.isFinished()).toBeFalsy()

    describe 'with timer that ran out', ->
      beforeEach ->
        @model.set timer: 0

      it 'returns true', ->
        expect(@model.isFinished()).toBeTruthy()

  describe '#isLoaded', ->
    describe 'with a loaded timelet', ->
      beforeEach ->
        @model.set loaded: true

      it 'returns true', ->
        expect(@model.isLoaded()).toBeTruthy()

    describe 'with an unloaded timelet', ->
      beforeEach ->
        @model.set loaded: false

      it 'returns true', ->
        expect(@model.isLoaded()).toBeFalsy()

  describe '#tick', ->
    it 'decrements the timer', ->
      @model.set timer: 42
      @model.tick()
      expect(@model.get('timer')).toEqual 41

    describe 'when the timer reached 0', ->
      beforeEach ->
        @model.set timer: 0

      it 'stops the timelet', ->
        spy = sinon.spy @model, 'stop'
        @model.tick()
        expect(spy).toHaveBeenCalled()

  describe '#load', ->
    beforeEach ->
      @model.set
        timer: 40
        duration: 79
        running: true
        loaded: false

    it 'rewinds the timelet in case it was already running', ->
      @model.load()
      expect(@model.get('timer')).toEqual 79
      expect(@model.get('running')).toBeFalsy()
      expect(@model.get('loaded')).toBeTruthy()

  describe '#unload', ->
    beforeEach ->
      @model.set loaded: true

    it 'marks the timelet as not loaded', ->
      @model.unload()
      expect(@model.get('loaded')).toBeFalsy()
        
  describe '#start', ->
    beforeEach ->
      @model.set
        timer: 10
        duration: 30
        running: false

    describe 'with a finished timer', ->
      beforeEach ->
        @model.set timer: 0

      it 'does nothing', ->
        @model.start()
        expect(@model.runner).toBeUndefined()

    describe 'with an invalid timer', ->
      beforeEach ->
        @model.set timer: 'abc'

      it 'does nothing', ->
        @model.start()
        expect(@model.runner).toBeUndefined()

    describe 'with a running timer', ->
      beforeEach ->
        @model.set running: true

      it 'does nothing', ->
        @model.start()
        expect(@model.runner).toBeUndefined()

    describe 'with a valid timer', ->
      it 'starts the timer', ->
        @model.start()
        expect(@model.runner).toBeDefined()

  describe '#stop', ->
    it 'stops the countdown', ->
      @model.runner = 123
      @model.stop()
      expect(@model.runner).toBeUndefined()

  describe '#pause', ->
    describe 'when running', ->
      beforeEach ->
        @model.set running: true

      it 'stops the timer', ->
        spy = sinon.spy @model, 'stop'
        @model.pause()
        expect(spy).toHaveBeenCalled()
        spy.restore()

    describe 'when stopped', ->
      beforeEach ->
        @model.set running: false

      it 'starts the timer', ->
        spy = sinon.spy @model, 'start'
        @model.pause()
        expect(spy).toHaveBeenCalled()
        spy.restore()

  describe '#restart', ->
    describe 'when finished', ->
      beforeEach ->
        @model.set
          timer: 0
          running: false
          duration: 32

      it 'restores the timer', ->
        expect(@model.get('timer')).toEqual 0
        @model.restart()
        expect(@model.get('timer')).toEqual 32

      it 'does not start the timer', ->
        expect(@model.get('running')).toBeFalsy()
        @model.restart()
        expect(@model.get('running')).toBeFalsy()
        expect(@model.runner).toBeUndefined()

    describe 'with an invalid duration', ->
      beforeEach ->
        @model.set
          duration: 'abc'
          timer: 10

      it 'restores the timer', ->
        expect(@model.get('timer')).toEqual 10
        @model.restart()
        expect(@model.get('timer')).toEqual 'abc'

      it 'does nothing', ->
        @model.restart()
        expect(@model.runner).toBeUndefined()

    describe 'when paused', ->
      beforeEach ->
        @model.set
          running: false
          duration: 28
          timer: 17

      it 'restores the timer', ->
        expect(@model.get('timer')).toEqual 17
        @model.restart()
        expect(@model.get('timer')).toEqual 28

      it 'does not start the timer', ->
        expect(@model.get('running')).toBeFalsy()
        @model.restart()
        expect(@model.get('running')).toBeFalsy()
        expect(@model.runner).toBeUndefined()

    describe 'when running', ->
      beforeEach ->
        @model.set
          running: true
          duration: 67
          timer: 13

      it 'restores the timer', ->
        expect(@model.get('timer')).toEqual 13
        @model.restart()
        expect(@model.get('timer')).toEqual 67

      it 'does not stop the timer', ->
        expect(@model.get('running')).toBeTruthy()
        @model.restart()
        expect(@model.get('running')).toBeTruthy()
        expect(@model.runner).toBeDefined()
