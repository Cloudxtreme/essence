describe 'Essence.Timelet', ->

  describe '#constructor', ->
    it 'starts the module router', ->
      spy = sinon.spy Essence.Timelet, 'Router'
      new Essence.Timelet()
      expect(spy).toHaveBeenCalled()
      spy.restore()

  describe '#setup', ->
    beforeEach ->
      new Essence.Timelet().setup()

    it 'renders the Timelet layout', ->
      expect($('#container')).toContain 'article.timelets'

  describe '#showTimelets', ->
    beforeEach ->
      @module = new Essence.Timelet()

    afterEach ->

    it 'fetches all timelets', ->
      spy = sinon.spy Backbone, 'sync'
      @module.showTimelets()
      expect(spy).toHaveBeenCalled()
      expect(spy.args[0][0]).toEqual 'read'
      expect(spy.args[0][1]).toBeAnInstanceOf Essence.Collections.Timelets
      spy.restore()

    describe 'with an ID', ->
      it 'fetches the timelet with that ID', ->
        spy = sinon.spy Backbone, 'sync'
        @module.showTimelets 1
        expect(spy).toHaveBeenCalled()
        expect(spy.args[1][0]).toEqual 'read'
        expect(spy.args[1][1]).toBeAnInstanceOf Essence.Models.Timelet
        spy.restore()
