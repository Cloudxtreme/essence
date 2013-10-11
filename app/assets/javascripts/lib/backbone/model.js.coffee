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

  # Saves values from DOM input fields.
  #
  # Input fields must have a matching `name` attribute linking it to
  # the model's attribute. Values are extracted depending on the
  # default value type of the attribute.
  #
  # Attributes that don't exist already on the model will be ignored.
  #
  # @param [jQuery.Element] element Element to retrieve the value from.
  #
  setFromInputElement: (element) ->
    return unless element

    attribute = element.attr 'name'

    return unless @has attribute

    switch element.attr 'type'
      when 'text', 'textarea' then value = element.val()
      when 'checkbox'         then value = element.is ':checked'
      else return

    @setStrict attribute, value
