describe 'Essence.Views.Timelets', ->
  beforeEach ->
    @model = new Essence.Models.Timelet
      name: 'Awesome timer'
      duration: 42
      running: true
      timer: 10
    @collection = new Essence.Collections.Timelets [@model]
    @view = new Essence.Views.Timelets model: @model, collection: @collection
    @html = @view.render().$el

    setFixtures @html

  afterEach ->
    clearInterval @view.runner

  describe '#constructor', ->
    it 'creates a composite view', ->
      expect(@view).toBeAnInstanceOf Backbone.Marionette.CompositeView

    it 'sets the model and collection', ->
      expect(@view.model).toBe @model
      expect(@view.collection).toBe @collection

  describe '#initialize', ->
    it 'renders on collection sync', ->
      @model.set name: 'Foobar timer'
      expect(@html.find('section.timelets')).toContainText 'Awesome timer'
      @collection.trigger 'sync'
      expect(@html.find('section.timelets')).toContainText 'Foobar timer'

    it 'renders on model sync', ->
      @model.set name: 'Foobar timer'
      expect(@html.find('section.clock')).toContainText 'Awesome timer'
      @model.trigger 'sync'
      expect(@html.find('section.clock')).toContainText 'Foobar timer'

    it 'renders the timer on timer change', ->
      expect(@html.find('section.clock')).toContainText '10'
      @model.set timer: 8
      expect(@html.find('section.clock')).toContainText '8'

    it 'renders the button on status change', ->
      @model.set running: false
      expect(@view.ui.clockStart).not.toHaveClass 'running'
      @model.set running: true
      expect(@view.ui.clockStart).toHaveClass 'running'

    it 'loads the timelet on timelet load', ->
      spy = sinon.spy @view, 'loadTimelet'
      @view.trigger 'itemview:timelet:load', model: 'modelStub'
      expect(spy).toHaveBeenCalledWith 'modelStub'
      spy.restore()

  describe '#render', ->
    it 'shows the clock', ->
      expect(@html).toContain 'section.clock'
      expect(@html.find('section.clock')).toContainText 'Awesome timer'

    it 'shows the timelets list', ->
      expect(@html).toContain 'section.timelets'
      expect(@html.find('section.timelets')).toContainText 'Awesome timer'

  describe '#loadTimelet', ->
    it 'stops any currently running clocks', ->
      spy = sinon.spy @view, 'stopTimelet'
      @view.loadTimelet @model
      expect(spy).toHaveBeenCalled()
      spy.restore()

    it 'rewinds the timelet in case it was already running', ->
      expect(@model.get('timer')).toEqual 10
      expect(@model.get('running')).toBeTruthy()
      @view.loadTimelet @model
      expect(@model.get('timer')).toEqual 42
      expect(@model.get('running')).toBeFalsy()

    it 'loads the timelets attributes into the clock', ->
      expect(@model.get('name')).toEqual 'Awesome timer'
      @view.loadTimelet new Essence.Models.Timelet name: 'Fantasic timer'
      expect(@model.get('name')).toEqual 'Fantasic timer'

    it 'renders the timelets into the clock', ->
      expect(@html.find('section.clock')).toContainText 'Awesome timer'
      @view.loadTimelet new Essence.Models.Timelet name: 'Fantasic timer'
      expect(@html.find('section.clock')).toContainText 'Fantasic timer'

  describe '#playTimelet', ->
    describe 'with a running clock', ->
      beforeEach ->
        @model.set running: true

      it 'stops the clock', ->
        spy = sinon.spy @view, 'stopTimelet'
        @view.playTimelet()
        expect(spy).toHaveBeenCalled()
        spy.restore()

    describe 'with a stopped clock', ->
      beforeEach ->
        @model.set running: false

      it 'starts the clock', ->
        spy = sinon.spy @view, 'startTimelet'
        @view.playTimelet()
        expect(spy).toHaveBeenCalled()
        spy.restore()

  describe '#startTimelet', ->

    describe 'with a finished timelet', ->
      beforeEach ->
        @model.set timer: 0

      it 'does nothing', ->
        @view.startTimelet()
        expect(@view.runner).toBeUndefined()

    describe 'with an invalid timelet', ->
      beforeEach ->
        @model.set timer: 'abc'

      it 'does nothing', ->
        @view.startTimelet()
        expect(@view.runner).toBeUndefined()

    describe 'with a valid timelet', ->
      it 'starts the timer', ->
        @view.startTimelet()
        expect(@view.runner).toBeDefined()

      it 'prevents the timer from being edited', ->
        @view.ui.clockTimer.attr 'contentEditable', 'true'
        @view.startTimelet()
        expect(@view.ui.clockTimer).not.toHaveAttr 'contentEditable'

  describe '#stopTimelet', ->
    it 'stops the countdown', ->
      @view.runner = 123
      @view.stopTimelet()
      expect(@view.runner).toBeUndefined()

    it 'allows the timer to be edited', ->
      @view.ui.clockTimer.removeAttr 'contentEditable'
      @view.stopTimelet()
      expect(@view.ui.clockTimer).toHaveAttr 'contentEditable'

  describe '#tick', ->
    it 'decrements the timer of the timelet', ->
      @model.set timer: 42
      @view.tick()
      expect(@model.get('timer')).toEqual 41

    describe 'when the timer reached 0', ->
      beforeEach ->
        @model.set timer: 0

      it 'stops the timelet', ->
        spy = sinon.spy @view, 'stopTimelet'
        @view.tick()
        expect(spy).toHaveBeenCalled()

  describe '#saveTimelet', ->
    describe 'with a new timelet', ->
      beforeEach ->
        @view.model = new Essence.Models.Timelet id: 456, name: 'Funky timer'

      it 'adds the current timelet to the collection', ->
        expect(@collection.length).toEqual 1
        expect(@collection.findWhere(name: 'Funky timer')).toBeUndefined()
        @view.saveTimelet()
        expect(@collection.length).toEqual 2
        expect(@collection.findWhere(name: 'Funky timer')).toBeDefined()

    describe 'with a modified timelet', ->
      it 'merges the current timelet with the collection', ->
        expect(@collection.length).toEqual 1
        expect(@collection.findWhere(name: 'Funky timer')).toBeUndefined()
        @view.model.set name: 'Funky timer'
        @view.saveTimelet()
        expect(@collection.length).toEqual 1
        expect(@collection.findWhere(name: 'Funky timer')).toBeDefined()

    it 'saves the model', ->
      spy = sinon.spy @model, 'save'
      @view.saveTimelet()
      expect(spy).toHaveBeenCalled()
      spy.restore()

  describe '#createTimelet', ->
    it 'saves any changes to the current timelet', ->
      spy = sinon.spy @view.model, 'save'
      @view.createTimelet()
      expect(spy).toHaveBeenCalled()
      spy.restore()

    it 'instanciates a new timelet', ->
      expect(@view.model.cid).toEqual @model.cid
      @view.createTimelet()
      expect(@view.model.cid).not.toEqual @model.cid

    it 'navigates to the index', ->
      @view.createTimelet()
      expect(@navigation).toHaveBeenCalledWith '/timelet'

  describe '#updateName', ->
    beforeEach ->
      @view.model.set name: 'Nada'
      @view.ui.clockTitle.text 'Something indeed'
      @view.ui.clockSave.css display: 'none'

    it 'copies the name from the field to the model', ->
      @view.updateName()
      expect(@view.model.get('name')).toEqual 'Something indeed'

    it 'displays the save button', ->
      @view.updateName()
      expect(@view.model.hasChanged('name')).toBeTruthy()
      expect(@view.ui.clockSave).not.toHaveCss display: 'none'

    describe 'when the name did not change', ->
      beforeEach ->
        @view.ui.clockTitle.text 'Nada'

      it 'does not display the save button', ->
        @view.updateName()
        expect(@view.ui.clockSave).toHaveCss display: 'none'

  describe '#updateDuration', ->
    beforeEach ->
      @view.model.set duration: 45
      @view.ui.clockTimer.text '42'
      @view.ui.clockSave.css display: 'none'

    it 'copies the duration from the field to the model', ->
      @view.updateDuration()
      expect(@view.model.get('duration')).toEqual 42

    it 'displays the save button', ->
      @view.updateDuration()
      expect(@view.model.hasChanged('duration')).toBeTruthy()
      expect(@view.ui.clockSave).not.toHaveCss display: 'none'

    describe 'when the duration did not change', ->
      beforeEach ->
        @view.ui.clockTimer.text '45'

      it 'does not display the save button', ->
        @view.updateDuration()
        expect(@view.ui.clockSave).toHaveCss display: 'none'

  describe '#renderTimer', ->
    it 'renders the time directly', ->
      @view.renderTimer()

  describe '#renderPlayButton', ->
    describe 'with a running clock', ->
      beforeEach ->
        @view.model.set running: true
        @view.ui.clockStart.addClass 'running'

      it 'removes the running class from the start button', ->
        @view.renderPlayButton()
        expect(@view.ui.clockStart).not.toHaveClass 'running'

    describe 'with a stopped clock', ->
      beforeEach ->
        @view.model.set running: false
        @view.ui.clockStart.removeClass 'running'

      it 'sets the running class to the start button', ->
        @view.renderPlayButton()
        expect(@view.ui.clockStart).toHaveClass 'running'
