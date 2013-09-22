# A modified required-validator for Select2 fields with multiple values.
#
# It works like the original 'required' validator, but also checks for
# empty arrays and objects.
#
# @see Backbone.Form.validators.required
#
_.extend Backbone.Form.validators,
  required: (options) ->
    options = _.extend
      type: 'required'
      message: @errMessages.required
    , options

    (value) ->
      options.value = value

      err =
        type: options.type
        message: Backbone.Form.helpers.createTemplate options.message, options

      if (_.isArray(value) or _.isObject(value)) and _.isEmpty(value)
        return err

      if value is null or value is undefined or value is false or value is ''
        return err
