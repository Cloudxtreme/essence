describe 'Essence.Views.Clock', ->
  beforeEach ->
    @model = new Essence.Models.Timelet

    @view = new Essence.Views.Clock model: @model
    @html = @view.render().$el

    # setFixtures @html
  
  describe '#constructor', ->
    it 'creates an item view', ->
      expect(@view).toBeAnInstanceOf Backbone.Marionette.ItemView

  describe '#render', ->
    it 'renders the clock', ->
      expect(@html).toContain 'section.countdown'
