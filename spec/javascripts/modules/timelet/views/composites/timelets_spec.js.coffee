describe 'Essence.Views.Timelets', ->
  beforeEach ->
    @model = new Essence.Models.Timelet
      name: 'Awesome timer'
      duration: 42
    @model.state.running = true
    @model.state.timer = 10

    @collection = new Essence.Collections.Timelets [@model]

    @parent = new Essence.Views.TimeletsPanel model: @model, collection: @collection
    @view = new Essence.Views.Timelets model: @model, collection: @collection, parent: @parent
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
    it 'loads the timelet on timelet load', ->
      stub = sinon.stub @view.options.parent, 'trigger'
      model = new Essence.Models.Timelet
      @view.collection.add model
      @view.trigger 'itemview:timelet:load', model: model
      expect(stub).toHaveBeenCalledWith 'timelet:load', model.id
      stub.restore()

  describe '#render', ->
    it 'shows the timelets list', ->
      expect(@view.ui.timelets).toContainText 'Awesome timer'

  describe '#createTimelet', ->
    it 'adds a new timelet to the collection', ->
      expect(@collection.length).toEqual 1
      @view.createTimelet()
      expect(@collection.length).toEqual 2

    it 'navigates to the index', ->
      @view.createTimelet()
      expect(@navigation).toHaveBeenCalledWith '/timelet'
