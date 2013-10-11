describe 'Essence.Views.Clock', ->
  beforeEach ->
    @model = new Essence.Models.Timelet
      name: 'Awesome timer'
      duration: 42
    @model.state.running = true
    @model.state.timer = 10

    @collection = new Essence.Collections.Timelets [@model]
    @model.collection = @collection

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
      stub = sinon.stub @view, 'render'
      @view.initialize()
      @model.trigger 'sync'
      expect(stub).toHaveBeenCalled()
      stub.restore()

    it 'renders the clock when it ticks', ->
      stub = sinon.stub @view, 'renderTimer'
      @view.initialize()
      @model.trigger 'tick'
      expect(stub).toHaveBeenCalled()
      stub.restore()

    it 'renders the button when the timelet starts', ->
      stub = sinon.stub @view, 'applyRunningState'
      @view.initialize()
      @model.trigger 'start'
      expect(stub).toHaveBeenCalled()
      stub.restore()

    it 'renders the button when the timelet stops', ->
      stub = sinon.stub @view, 'applyRunningState'
      @view.initialize()
      @model.trigger 'stop'
      expect(stub).toHaveBeenCalled()
      stub.restore()

    it 'plays an alert when the timelet alerts', ->
      stub = sinon.stub @view, 'alert'
      @view.initialize()
      @model.trigger 'alert'
      expect(stub).toHaveBeenCalled()
      stub.restore()

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

  describe '#stopTimelet', ->
    it 'delegates to the model', ->
      stub = sinon.stub @model, 'stop'
      @view.stopTimelet()
      expect(stub).toHaveBeenCalled()
      stub.restore()

  describe '#restartTimelet', ->
    it 'delegates to the model', ->
      stub = sinon.stub @model, 'restart'
      @view.restartTimelet()
      expect(stub).toHaveBeenCalled()
      stub.restore()

    it 'updates the timer value', ->
      @view.renderTimer()
      expect(@view.ui.clockTimer).toContainText '10'
      @view.restartTimelet()
      expect(@view.ui.clockTimer).toContainText '42'

  describe '#alert', ->
    it 'plays a sound file', ->
      stub = sinon.stub Essence.AudioPlayer, 'play'
      @view.alert()
      expect(stub).toHaveBeenCalled()

  describe '#renderTimer', ->
    it 'renders the timer', ->
      @view.renderTimer()
      expect(@view.ui.clockTimer).toContainText '10'
      @model.state.timer = 40
      @view.renderTimer()
      expect(@view.ui.clockTimer).toContainText '40'

  describe '#applyRunningState', ->
    describe 'with a running clock', ->
      beforeEach ->
        @model.state.running = true
        @view.$el.removeClass 'running'

      it 'sets the running class to the entire view', ->
        @view.applyRunningState()
        expect(@view.$el).toHaveClass 'running'

    describe 'with a stopped clock', ->
      beforeEach ->
        @model.state.running = false
        @view.$el.addClass 'running'

      it 'removes the running class from the view', ->
        @view.applyRunningState()
        expect(@view.$el).not.toHaveClass 'running'
