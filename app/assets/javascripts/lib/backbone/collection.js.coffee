# Backbone.Collection extensions for the REST API responder.
#
class Essence.Collection extends Backbone.Collection

  # Essence REST API backend sync implementation
  sync: Essence.Backend.sync

  # Construct an Essence collection.
  #
  # @param models [Array<Object>] the model attributes
  # @param options [Object] the collection options
  #
  constructor: (models, options = {}) ->
    super models, options

    @filters or= options.filters || {}
    @sorters or= options.sorters || {}
    @query   or= options.query || null
    @start   or= options.start || 0
    @limit   or= options.limit || 25

    @parent  or= options.parent

  # Make a simple backend search on the collection. A search
  # ignores filters and tree structurea
  #
  # @param [String] query the search term
  # @return [String, null] the current search
  #
  search: (query = '') ->
    unless query is ''
      @query = query
    else
      @query = null

    @query

  # Parse the result from a collection fetch().
  #
  # @param response [Hash] the server response
  # @param xhr [XmlHttpRequest] the AJAX request
  # @return [Array] the model data
  #
  parse: (response, xhr) ->
    if response.success then response.data else response

  # Add a filter to this collection. This is used for filtering
  # the collection at the backend.
  #
  # @param field [String] the field name to sort
  # @param value [String] the value to filter
  # @param type [String] optional value describing the type of the filter further
  # @return [Essence.Collection] the current collection
  #
  addFilter: (field, value, type) ->
    type ?= 'string'
    @filters[field] = { v: value, t: type }
    @

  # Clear the collection filter. If the field is not given,
  # all filters will be cleared.
  #
  # @params field [String] the filter field to clear
  # @return [Essence.Collection] the current collection
  #
  removeFilter: (field) ->
    if _.isUndefined field then @filters = {} else delete @filters[field]
    @

  # Add a sorter to this collection. This is used for sorting
  # the collection at the backend.
  #
  # @param field [String] the name of the field to sort
  # @param direction [String] the sort direction, either ASC or DESC
  # @return [Essence.Collection] the current collection
  #
  addSorter: (field, direction) ->
    @sorters[field] = direction
    @

  # Clear the collection sorter. If the field is not given,
  # all sorters will be cleared.
  #
  # @params field [String] the sort field to clear
  # @return [Essence.Collection] the current collection
  #
  removeSorter: (field) ->
    if _.isUndefined field then @sorters = {} else delete @sorters[field]
    @

  # Appends the next results to the collection. This needs a
  # collection to be initialized with a limit
  #
  # @example Page a collection
  #   collection = new Backbone.Collection([], { limit: 3 })
  #   collection.fetch()
  #   collection.fetchNext()
  #
  # @param [Fixnum] initial the initial number of items to show
  # @param [Fixnum] sibsequent the subsequent number of items to load
  #
  fetchNext: (initial=3, subsequent=5) ->
    if @start then @start += subsequent else @start = initial
    @limit = subsequent
    @fetch(update: true, remove: false)

  # Test if the collection is filtered in any way, either
  # with a filter or a search.
  #
  # @return [Boolean] the filter status
  #
  isFiltered: ->
    !(_.isEmpty(@query) && _.isEmpty(@filters))
