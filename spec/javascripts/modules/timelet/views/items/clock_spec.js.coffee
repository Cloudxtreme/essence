describe 'Essence.Views.Clock', ->
  beforeEach ->
    @collection = new Essence.Collections.Timelets
      name: 'Awesome timer'
      duration: 42
      running: true
      timer: 10
    @model = @collection.at 0

    @parent = new Essence.Views.TimeletsPanel model: @model, collection: @collection
    @view = new Essence.Views.Clock model: @model, parent: @parent
    @html = @view.render().$el

    setFixtures @html

  afterEach ->
    clearInterval @view.runner

  describe '#constructor', ->
    it 'creates an item view', ->
      expect(@view).toBeAnInstanceOf Backbone.Marionette.ItemView

    it 'sets the model', ->
      expect(@view.model).toBe @model

  describe '#initialize', ->
    it 'renders on model sync', ->
      @model.set name: 'Foobar timer'
      expect(@view.ui.clockTitle).toContainText 'Awesome timer'
      @model.trigger 'sync'
      expect(@view.ui.clockTitle).toContainText 'Foobar timer'

    it 'renders the timer on timer change', ->
      expect(@view.ui.clockTimer).toContainText '10'
      @model.set timer: 8
      expect(@view.ui.clockTimer).toContainText '8'

    it 'renders the button on status change', ->
      @model.set running: false
      expect(@view.$el).not.toHaveClass 'running'
      @model.set running: true
      expect(@view.$el).toHaveClass 'running'

  describe '#render', ->
    it 'shows the clock', ->
      expect(@view.ui.clockTitle).toContainText 'Awesome timer'

  describe '#pauseTimelet', ->
    it 'delegates to the model', ->
      stub = sinon.stub @model, 'pause'
      @view.pauseTimelet()
      expect(stub).toHaveBeenCalled()
      stub.restore()

  describe '#startTimelet', ->
    it 'delegates to the model', ->
      stub = sinon.stub @model, 'start'
      @view.startTimelet()
      expect(stub).toHaveBeenCalled()
      stub.restore()

  describe '#restartTimelet', ->
    it 'delegates to the model', ->
      stub = sinon.stub @model, 'restart'
      @view.restartTimelet()
      expect(stub).toHaveBeenCalled()
      stub.restore()

  describe '#stopTimelet', ->
    it 'delegates to the model', ->
      stub = sinon.stub @model, 'stop'
      @view.stopTimelet()
      expect(stub).toHaveBeenCalled()
      stub.restore()

  describe '#saveTimelet', ->
    describe 'with a new timelet', ->
      beforeEach ->
        @view.model = new Essence.Models.Timelet { id: 456, name: 'Funky timer' }, collection: @collection

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

    it 'navigates to the new model', ->
      @view.saveTimelet()
      expect(@navigation).toHaveBeenCalledWith "/timelet/#{ @model.id }"

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
        @view.$el.removeClass 'running'

      it 'sets the running class to the start button', ->
        @view.renderPlayButton()
        expect(@view.$el).toHaveClass 'running'

    describe 'with a stopped clock', ->
      beforeEach ->
        @view.model.set running: false
        @view.$el.addClass 'running'

      it 'removes the running class from the start button', ->
        @view.renderPlayButton()
        expect(@view.$el).not.toHaveClass 'running'

  describe '#toggleTimerEditability', ->
    describe 'with a running clock', ->
      beforeEach ->
        @view.ui.clockTimer.attr 'contentEditable', 'true'

      it 'prevents the timer from being edited', ->
        @view.toggleTimerEditability @model, true
        expect(@view.ui.clockTimer).not.toHaveAttr 'contentEditable'

    describe 'with a stopped clock', ->
      beforeEach ->
        @view.ui.clockTimer.removeAttr 'contentEditable'

      it 'allows the timer to be edited', ->
        @view.toggleTimerEditability @model, false
        expect(@view.ui.clockTimer).toHaveAttr 'contentEditable'
