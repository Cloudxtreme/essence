describe 'Essence.Views.NoTimelet', ->
  beforeEach ->
    @view = new Essence.Views.NoTimelet
    @html = @view.render().$el

    setFixtures @html

  describe '#render', ->
    it 'renders the no-timlets-found message', ->
      expect(@html).toHaveText "You didn't save any timelets yet."
