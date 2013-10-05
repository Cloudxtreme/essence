# Base Model class with universal helper methods.
#
class Essence.Model extends Backbone.Model

  # Sets a single attribute converted to its declared type.
  #
  # Type declaration is derived from the default value.
  #
  # @param [Any] attribute Attribute to be set
  # @param [Any] value Value to be set
  #
  setStrict: (attribute, value) ->
    value = parseInt(value) if typeof @defaults?[attribute] is 'number'
    @set attribute, value
