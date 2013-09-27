describe 'Essence.Models.Timelet', ->
  beforeEach ->
    @model = new Essence.Models.Timelet

  describe '#constructor', ->
    it 'creates a Backbone model', ->
      expect(@model).toBeAnInstanceOf Backbone.Model

  describe '#fetch', ->
    it 'loads the model from localStorage', ->
      spy = sinon.spy Backbone, 'localSync'
      @model.set id: 1
      @model.fetch()
      expect(spy).toHaveBeenCalled()
      spy.restore()

  describe '#validate', ->
    it 'succeeds with valid attributes', ->
      @model.set timer: 23, duration: 40
      expect(@model.isValid()).toBeTruthy()

    it 'fails without a duration', ->
      @model.set timer: 23
      expect(@model.isValid()).toBeFalsy()

    it 'fails without a timer', ->
      @model.set duration: 23
      expect(@model.isValid()).toBeFalsy()

    it 'fails with an invalid timer', ->
      @model.set timer: 'abc', duration: 23
      expect(@model.isValid()).toBeFalsy()

    it 'fails with an invalid duration', ->
      @model.set timer: 23, duration: 'abc'
      expect(@model.isValid()).toBeFalsy()

    it 'fails with a too small duration', ->
      @model.set timer: 23, duration: 0
      expect(@model.isValid()).toBeFalsy()

    it 'fails with a timer that ran out', ->
      @model.set timer: 0, duration: 40
      expect(@model.isValid()).toBeFalsy()
