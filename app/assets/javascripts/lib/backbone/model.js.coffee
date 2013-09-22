# Backbone.Model extensions for the REST API responder.
#
# The Essence model has some special configuration options:
#
# ## Volatile attribute
#
# A volatile attribute is an attribute that is read-only and
# is skipped when POST or PUT to the backend.
#
# @example Define a volatile attribute
#   class SuperModel extends Essence.Model
#     volatile: [
#       'ignoreMe'
#     ]
#
# ## Transpose attribute
#
# A transposed attribute changes its form when saving to
# the backend. For example when getting an industry in an object,
# the industry itself will be an object, containing its id and name.
# But when saving the the model, we just send back the updated industry id.
#
# @example Define a transposed attribute
#   class SuperModel extends Essence.Model
#     transpose:
#       industry: 'industry_id'
#
# Transposition makes also sure, that an attribute that is transposed to
# another attribute that ends in `_id`, that any existing object will be dropped
# and the id will be taken instead.
#
class Essence.Model extends Backbone.DeepModel

  # The name of the root element for the request data
  dataRoot: 'data'

  # Whether the sync should also perform the read operation in the namespace like `pro` and `user`.
  useRootNamespaceForRead: false

  # Sync the model or collection with the backend.
  #
  # @param method [String] the action to do
  # @param model [Essence.Model,Essence.Collection] the model or collection to sync
  # @param options [Object] the sync options
  # @option options [Boolean] notify whether to notify about success or error
  #
  sync: (method, model, options = {}) ->
    if method is 'read' and @useRootNamespaceForRead
      options.url or= @url().replace /pro\/|user\//, ''

    Essence.Backend.sync(method, model, options)

  # Construct an Extranett model.
  #
  # @param attributes [Object] the model attributes
  # @param options [Object] the model options
  #
  constructor: (attributes = {}, options = {}) ->
    super attributes, options

    # Save the parent model
    @parent  or= options.parent || options.collection?.parent

    # Moves the attributes from the `dataRoot` property
    if @hasDataRoot(attributes)
      @set attributes[@dataRoot], { silent: true }
      @unset @dataRoot, { silent: true }
      @._previousAttributes = _.clone @attributes

  # Check if the given attribute object has a `dataRoot` property.
  #
  # @param attributes [Object] the model attributes
  # @return [Boolean] true when has a `dataRoot` property
  #
  hasDataRoot: (attributes) ->
    attributes.hasOwnProperty(@dataRoot) && typeof(attributes[@dataRoot]) is 'object'

  # This is called on all models coming in from a remote server.
  #
  # @param response [Object] the server response
  #
  parse: (response) ->
    if response['data'] && response['data'][0]
      response['data'][0]
    else
      response
