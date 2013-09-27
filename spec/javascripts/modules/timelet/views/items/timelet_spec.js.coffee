describe 'Essence.Views.Timelet', ->
  beforeEach ->
    @model = new Essence.Models.Timelet
      id: 123
      name: 'My test Timelet'
      duration: 33
    @view = new Essence.Views.Timelet model: @model
    @html = @view.render().$el

    setFixtures @html

  describe '#render', ->
    it 'renders the model', ->
      expect(@html).toContain '.name:contains(My test Timelet)'

    it 'renders a delete button', ->
      expect(@html).toContain '.button.delete'

    it 'renders a load button', ->
      expect(@html).toContain '.button.load'

  describe '#delete', ->
    it 'destroys the model', ->
      spy = sinon.spy @model, 'destroy'
      @view.delete()
      expect(spy).toHaveBeenCalled()
      spy.restore()

  describe '#load', ->
    it 'triggers the load event', ->
      spy = sinon.spy @view, 'trigger'
      @view.load()
      expect(spy).toHaveBeenCalledWith 'timelet:load'
      spy.restore()

    it 'navigates to route for the this timelet', ->
      @view.load()
      expect(@navigation).toHaveBeenCalledWith "/timelet/#{ @model.id }"
