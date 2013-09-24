#= require application
#= require spec/sinon
#= require spec/jasmine-sinon
#= require spec/jasmine-jquery
#= require_tree .

invoke = (method_name, args...) ->
  if _.isFunction(@actual[method_name])
    @actual[method_name].apply(@actual, args)
  else
    args.unshift(@actual)
    _[method_name].apply(@actual, args)

beforeEach ->
  # Provide a global stub for Backbone navigation in order
  # to prevent changing the URL during the test run.
  @navigation = sinon.stub Backbone.history, 'navigate'

  # Create the HTMl base structure for the applciation
  $('body').append '<div id="container"></div>'

  # Start the application
  window.Essence.application = new Essence.Application()
  Essence.application.start()

  #Essence.collections.notifications().reset()

  # No animations during the spec run
  jQuery.fx.off = true

  # Use English UI for testing
  I18n.locale = 'en'
  #moment.lang 'en'

  # Custom Jasmine matchers
  #
  @addMatchers {
    toBeArray: ->
      invoke.call(this, 'isArray')

    toBeFunction: ->
      invoke.call(this, 'isFunction')

    toBeBoolean: ->
      invoke.call(this, 'isBoolean')

    toBeNumber: ->
      invoke.call(this, 'isNumber')

    toBeString: ->
      invoke.call(this, 'isString')

    toBeDate: ->
      invoke.call(this, 'isDate')

    toBeEmpty: ->
      invoke.call(this, 'isEmpty')

    toInclude: (items...) ->
      _(items).all (item) =>
        invoke.call(this, 'include', item)

    toIncludeAny: (items...) ->
      _(items).any (item) =>
        invoke.call(this, 'include', item)

    toBeCompact: ->
      elements = invoke.call(this, 'map', _.identity)
      _.isEqual elements, _.compact(elements)

    toBeUnique: ->
      elements = invoke.call(this, 'map', _.identity)
      _.isEqual elements, _.uniq(elements)

    toRespondTo: (methods...)->
      _.all methods, (method) =>
        _.isFunction(@actual[method])

    toRespondToAny: (methods...)->
      _.any methods, (method) =>
        _.isFunction(@actual[method])

    toHave: (attrs...) ->
      _.all attrs, (attr) =>
        @actual.has(attr)

    toHaveAny: (attrs...) ->
      _.any attrs, (attr) =>
        @actual.has(attr)

    toBeAnInstanceOf: (clazz) ->
      @actual instanceof clazz

    toBeA: (clazz) ->
      @actual instanceof clazz

    toBeAn: (clazz) ->
      @actual instanceof clazz

    toBeFocused: ->
      @actual.get(0) is @actual.get(0).ownerDocument.activeElement
  }

afterEach ->
  $('#container').remove()

  localStorage.clear()
  sessionStorage.clear()

  if Essence?.application
    delete Essence.application.currentUser
    delete Essence.application.token
    delete Essence.application.loginUserDeferred

  Essence?.collections?.notifications().reset()

  @navigation.restore()
