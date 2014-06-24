describe 'Essence.Views.TimeletsPanel', ->
  beforeEach ->
    @model = new Essence.Models.Timelet
      name: 'Awesome timer'
      duration: 42
    @model.state.running = true
    @model.state.timer = 10

    @collection = new Essence.Collections.Timelets [@model]
    @model.collection = @collection

    @view = new Essence.Views.TimeletsPanel model: @model, collection: @collection
    @html = @view.render().$el

    setFixtures @html

  afterEach ->
    clearInterval @view.runner

  describe '#constructor', ->
    it 'creates a layout', ->
      expect(@view).toBeAnInstanceOf Backbone.Marionette.LayoutView

    it 'sets the model and collection', ->
      expect(@view.model).toBe @model
      expect(@view.collection).toBe @collection

  describe '#initialize', ->
    it 'loads the timelet on timelet load', ->
      model = new Essence.Models.Timelet name: 'Fantastic timer'
      @collection.add model
      @view.trigger 'timelet:load', model.cid
      expect(@view.model.get('name')).toEqual 'Fantastic timer'

    describe 'fetching the collection', ->
      describe 'with a model ID', ->
        beforeEach ->
          @view.model = new Essence.Models.Timelet { id: 123 }, collection: @collection

        it 'loads the model as a timelet', ->
          stub = sinon.stub @view, 'loadTimelet'
          @model.trigger 'reset'
          expect(stub).toHaveBeenCalledWith 123
          stub.restore()

      describe 'without a model ID', ->
        it 'unloads all timelets', ->
          stub = sinon.stub @collection, 'unload'
          @model.trigger 'reset'
          expect(stub).toHaveBeenCalled()
          stub.restore()

  describe '#render', ->
    it 'shows the clock', ->
      expect(@html).toContain 'section.clock'
      expect(@html.find('section.clock')).toContainText 'Awesome timer'

    it 'shows the timelets list', ->
      expect(@html).toContain 'section.timelets'
      expect(@html.find('section.timelets input')).toHaveValue 'Awesome timer'

  describe '#loadTimelet', ->
    it 'stops any currently running clocks', ->
      spy = sinon.spy @view.clock.currentView, 'stopTimelet'
      @view.loadTimelet @model
      expect(spy).toHaveBeenCalled()
      spy.restore()

    it 'loads the timelet', ->
      stub = sinon.stub @model, 'load'
      @view.loadTimelet @model
      expect(stub).toHaveBeenCalled()
      stub.restore()

    it 'loads the timelets attributes into the clock', ->
      expect(@model.get('name')).toEqual 'Awesome timer'
      model = new Essence.Models.Timelet name: 'Fantasic timer'
      @view.collection.add model
      @view.loadTimelet model
      expect(@view.model.get('name')).toEqual 'Fantasic timer'

    it 'renders the timelets into the clock', ->
      expect(@html.find('section.clock')).toContainText 'Awesome timer'
      model = new Essence.Models.Timelet name: 'Fantasic timer'
      @view.collection.add model
      @view.loadTimelet model
      expect(@html.find('section.clock')).toContainText 'Fantasic timer'
