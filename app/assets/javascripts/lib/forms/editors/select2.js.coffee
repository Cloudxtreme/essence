# Select2 form type for Backbone.Forms
#
# Handles either data from a Backbone.Collection or a remote AJAX endpoint.
#
#= require ./backbone-forms.validators.required
#
class Backbone.Form.editors.Select2 extends Backbone.Form.editors.Text
  tagName: 'div'

  events:
    'change': -> @trigger 'change', @
    'blur':   -> @trigger 'blur', @
    'focus':  -> @trigger 'focus', @

  # Initialize the Select2 editor.
  #
  # @param [Object] options the editor options
  #
  initialize: (@options) ->
    super @options

    @input = $("<input name='#{ @getName() }' type='hidden' />")
    @$el.append @input

    # Update when collection has been loaded
    if @schema.options instanceof Backbone.Collection
      @schema.options.on 'reset', (collection) => @applyCollection(collection)

  # Render the select2 dropdown box. This adds a wrapper
  # dic arround the select element
  #
  # @return [Backbone.Form.editors.Select] the editor
  #
  render: =>
    if @schema.options instanceof Backbone.Collection
      @applyCollection(@schema.options)

    if _.isString @schema.options
      @applyRemote(@schema.options)

    if _.isObject @value
      @setValue(@value.id)
    else
      @setValue(@value)

    @

  # Applies the data from the Backbone collection to the
  # select2 select box
  #
  # @param [Backbone.Collection] collection the collection data
  # @param [Hash] toStringParams parameters to pass to the model's toString method
  #
  applyCollection: (collection, toStringParams) ->
    data = collection.map (model) -> { id: model.id, text: model.toString(toStringParams), data: model.attributes }

    config = _.extend({
      width: 'off'

      # Define the initial select2 selection
      #
      # @param [jQuery.fn] element the input element
      # @param [Function] callback the callback
      #
      initSelection : (element, callback) =>
        if @schema?.config?.multiple
          selected = for id in element.val().split(',')
            model = collection.get(id)
            if model then { id: model.id, text: model.toString(toStringParams), data: model.attributes } else null

          callback(_.compact(selected))
        else
          model = collection.get(element.val())
          callback({ id: model.id, text: model.toString(toStringParams), data: model.attributes }) if model

      # Provide translation when nothing matches
      #
      # @param [String] term the search term
      #
      formatNoMatches: (term) ->
        I18n.t('frontend.shared.no_match', { term: term })

      # Filter data when
      #
      # @param [Object] query the query object the call back
      #
      query: (query) =>
        value = @getValue()

        if _.isNumber value
          result = _.reject data, (item) -> item.id is value
        else if _.isArray value
          result = _.reject data, (item) -> _.indexOf(value, item.id) isnt -1
        else
          result = data

        query.callback({ results: _.filter(result, (item) -> item.text.toLowerCase().indexOf(query.term.toLowerCase()) isnt -1) })

    }, @schema.config, { data: data })

    @input.removeClass('select2-offscreen').select2(config)

  # Applies a remote endpoint to the select2
  #
  # @param [String] url the AJAX endpoint
  #
  applyRemote: (url) ->
    config = _.extend({
      width: 'off'
      minimumInputLength: 2

      ajax:
        url: url
        dataType: 'json'
        data: (term, page) -> { query: term }
        results: (data, page) -> { results: _.map(data.data, (data) -> { id: data.id, text: data.name, data: data }) }

      # Define the initial select2 selection
      #
      # @param [jQuery.fn] element the input element
      # @param [Function] callback the callback
      #
      initSelection : (element, callback) =>
        if @schema?.config?.multiple
          if _.isEmpty element.select2('data')

            results = []

            queries = for id in element.val().split(',')
              $.get "#{ url }/#{ id }", (data) ->
                data = data?.data?[0]
                if data then results.push({ id: data.id, text: data.name, data: data })

            $.when.apply($, queries).done -> callback results

        else
          unless element.select2('data')
            id = element.val()

            if id isnt -1
              $.get "#{ url }/#{ id }", (data) ->
                data = data?.data?[0]
                callback({ id: data.id, text: data.name, data: data }) if data

      # Provide translation when nothing matches
      #
      # @param [String] term the search term
      #
      formatNoMatches: (term) ->
        I18n.t('frontend.shared.no_match', { term: term })

    }, @schema.config)

    @input.removeClass('select2-offscreen').select2(config)

  # Determines if a new value is set
  #
  determineChange: ->
    currentValue = @getValue()

    if currentValue isnt @previousValue
      @previousValue = currentValue
      @trigger('change', @)

  # Get the selection data. By default this will
  # return either the id of the selected object
  # or an Array of ids of the selected objects.
  # By setting the config value `data` to `true`,
  # this conversion can be skipped.
  #
  # @return [String] the selection result
  #
  getValue: ->
    value = @input.select2('data')

    # Return full data instead just the id
    if @schema.config?.data
      if _.isArray(value)
        _.map value, (item) -> item.data
      else
        value?.data

    # Just return the id's
    else
      # Multiple objects are selected
      if _.isArray(value)
        _.map value, (item) -> item.id

      # A single object is selected
      else if _.isObject(value)
        value.id

      else
        undefined

  # Set the current value
  #
  setValue: (value) ->
    if _.isString value
      @input.select2('val', value)

    else if _.isArray value
      @input.select2 'val', _.map(value, (o) -> if o?.id then o.id else o)

    else if _.isObject value
      @input.select2 'val', if value?.id then value.id else value

    else if value
       @input.select2('val', value)

  # Focus the file input
  #
  focus: ->
    unless @hasFocus
      @input.focus()

  # Blur the file input
  #
  blur: ->
    if @hasFocus
      @input.blur()
