# A modal adapter for Backbone Forms List editor, that
# does not open a modal window :)
#
class Backbone.Form.editors.List.Modal.ModalAdapter

  constructor: (@options) ->
    _.extend @, Backbone.Events

    @form = @options.content

  open: ->
    console.log 'Open'
