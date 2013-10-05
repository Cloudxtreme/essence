describe 'Essence.Model', ->
  beforeEach ->
    @model = new Essence.Model

  describe '#constructor', ->
    it 'creates a Backbone model', ->
      expect(@model).toBeAnInstanceOf Backbone.Model

  describe '#setStrict', ->
    it 'sets the attribute value as-is', ->
      spy = sinon.spy @model, 'set'
      @model.setStrict 'seconds', '1'
      expect(spy).toHaveBeenCalledWith 'seconds', '1'
      spy.restore()

    describe 'for an Integer value', ->
      beforeEach ->
        @model.defaults =
          seconds: 0

      it 'sets the attribute value as an Integer', ->
        spy = sinon.spy @model, 'set'
        @model.setStrict 'seconds', '2'
        expect(spy).toHaveBeenCalledWith 'seconds', 2
        spy.restore()
