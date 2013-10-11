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

  describe '#setFromInputElement', ->
    beforeEach ->
      @element = $ '<input>'
      @stub = sinon.stub @model, 'setStrict'
      @model.defaults =
        name: ''
        duration: 0
        loop: false
      @model.set @model.defaults

    afterEach ->
      @stub.restore()

    describe 'with a new attribute', ->
      beforeEach ->
        @element.attr type: 'text', name: 'foo', value: 'bar'
        @model.setFromInputElement @element

      it 'does nothing', ->
        expect(@stub).not.toHaveBeenCalled()

    describe 'with an unsupported type', ->
      beforeEach ->
        @element.attr type: 'number', name: 'duration', value: '7'
        @model.setFromInputElement @element

      it 'does nothing', ->
        expect(@stub).not.toHaveBeenCalled()

    describe 'without an element', ->
      beforeEach ->
        @model.setFromInputElement()

      it 'does nothing', ->
        expect(@stub).not.toHaveBeenCalled()

    describe 'with a text input field', ->
      beforeEach ->
        @element.attr type: 'text', name: 'duration', value: '5'
        @model.setFromInputElement @element

      it 'sets the correct value', ->
        expect(@stub).toHaveBeenCalledWith 'duration', '5'

    describe 'with a text area', ->
      beforeEach ->
        @element.attr type: 'textarea', name: 'name', value: 'much text'
        @model.setFromInputElement @element

      it 'sets the correct value', ->
        expect(@stub).toHaveBeenCalledWith 'name', 'much text'

    describe 'with a checkbox', ->
      beforeEach ->
        @element.attr type: 'checkbox', name: 'loop'
        @element.prop checked: true
        @model.setFromInputElement @element

      it 'sets the correct value', ->
        expect(@stub).toHaveBeenCalledWith 'loop', true
