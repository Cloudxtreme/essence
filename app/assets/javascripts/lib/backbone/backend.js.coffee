# Backbone sync to the Rails backend.
#
# This adds backend model validations and triggers
# a 'error' event with the error messages:
#
# @example Server side validation errors
#   {
#     message: 'Cannot save'
#     errors: {
#       a: ['must be present'],
#       b: ['too small']
#     }
#   }
#
class Essence.Backend

  # Sync the model or collection with the backend.
  #
  # @param method [String] the action to do
  # @param model [Essence.Model,Essence.Collection] the model or collection to sync
  # @param options [Object] the sync options
  # @option options [Boolean] notify whether to notify about success or error
  #
  @sync: (method, model, options) ->

    # Map the request type
    #
    type = {
      'create': 'POST'
      'update': 'PUT'
      'patch' : 'PATCH'
      'delete': 'DELETE'
      'read'  : 'GET'
    }[method]

    # Set up AJAX parameters
    #
    params = _.extend {
      notify: true
      type: type
      dataType: 'json'

      # Modify the request before sending
      #
      # @param [jqXHR] the jQuery XHR object
      #
      beforeSend: (jqXHR) ->
        csrf = $('meta[name="csrf-token"]').attr 'content'
        jqXHR.setRequestHeader('X-CSRF-Token', csrf) if csrf

      # Global error notifications
      #
      # @param [jqXHR] the jQuery XHR object
      # @param [String] status the test status
      #
      complete: (jqXHR, status) ->
        data = try JSON.parse jqXHR.responseText

        # Request succeed
        #
        if status in ['success', 'notmodified']
          if params.notify and data.message
            Essence.collections.notifications().uniqueAdd
              message: data.message
              type: 'success'

        # Request error
        #
        else
          if params.notify
            message = data?.message || I18n.t 'frontend.shared.request_error'
            Essence.collections.notifications().uniqueAdd
              message: message
              type: 'error'

    }, options

    # Get request URL
    #
    if not params.url
      params.url = if _.isFunction(model.url) then model.url() else model.url

    # Set process data property
    #
    params.processData = false if params.type isnt 'GET'

    # Add request data
    #
    if not params.data && model && (method is 'create' || method is 'update')
      request = {}

      if model.paramRoot
        request[model.paramRoot] = model.toJSON()
      else
        request = model.toJSON()

      params.data = JSON.stringify(request)
      params.contentType = 'application/json'

    xhr = $.ajax params
    model.trigger 'request', model, xhr, options

    xhr

  # Get the path to the login dialog
  #
  # @private
  # @return [String] the relative path
  #
  @loginPath: ->
    path = Essence.Backend.location()

    if /^\/[a-z]{2}\/users\/login\/redirect/.test(path)
      path
    else
      "/#{ I18n.locale }/users/login/redirect/#{ path }"

  # Get the current location path
  #
  # @private
  # @return [String] the relative path
  #
  @location: ->
    window.location.pathname
