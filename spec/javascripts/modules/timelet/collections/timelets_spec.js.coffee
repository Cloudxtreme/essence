describe 'Essence.Collections.Timelets', ->
  beforeEach ->
    @collection = new Essence.Collections.Timelets

  describe '#constructor', ->
    it 'creates a collection', ->
      expect(@collection).toBeAnInstanceOf Backbone.Collection

  describe '.model', ->
    it 'serves as a collection for Timlet models', ->
      expect(@collection.model).toBe Essence.Models.Timelet

  describe '#fetch', ->
    it 'loads models from localStorage', ->
      spy = sinon.spy Backbone, 'localSync'
      @collection.fetch()
      expect(spy).toHaveBeenCalled()
      spy.restore()
