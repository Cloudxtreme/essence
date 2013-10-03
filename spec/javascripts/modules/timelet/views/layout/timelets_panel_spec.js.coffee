describe 'Essence.Views.TimeletsPanel', ->
  beforeEach ->
    @model = new Essence.Models.Timelet
      name: 'Awesome timer'
      duration: 42
      running: true
      timer: 10
    @collection = new Essence.Collections.Timelets [@model]
    @view = new Essence.Views.TimeletsPanel model: @model, collection: @collection
    @html = @view.render().$el

    setFixtures @html

  afterEach ->
    clearInterval @view.runner

  describe '#constructor', ->
    it 'creates a layout', ->
      expect(@view).toBeAnInstanceOf Backbone.Marionette.Layout

    it 'sets the model and collection', ->
      expect(@view.model).toBe @model
      expect(@view.collection).toBe @collection

  describe '#initialize', ->
    it 'loads the timelet on timelet load', ->
      model = new Essence.Models.Timelet name: 'Fantastic timer'
      @collection.add model
      @view.trigger 'timelet:load', model.cid
      expect(@view.model.get('name')).toEqual 'Fantastic timer'

    it 'creates a timelet on timelet create', ->
      @view.trigger 'timelet:create'
      expect(@view.model.get('name')).toEqual 'New timelet'

  describe '#render', ->
    it 'shows the clock', ->
      expect(@html).toContain 'section.clock'
      expect(@html.find('section.clock')).toContainText 'Awesome timer'

    it 'shows the timelets list', ->
      expect(@html).toContain 'section.timelets'
      expect(@html.find('section.timelets')).toContainText 'Awesome timer'

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
