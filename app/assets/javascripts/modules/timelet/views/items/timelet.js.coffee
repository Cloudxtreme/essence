# A single timelet view.
#
class Essence.Views.Timelet extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/timelet'
  tagName: 'li'

  ui:
    details: '.details'
    name:    '.name'
    save:    '.save'
    fields:  'input'

  events:
    'click .delete':           'delete'
    'click .load':             'load'
    'click .save':             'save'
    'click .close':            'collapse'
    'click input[name=name]':  'expand'
    'change input[type=text]': 'updateModel'

  initialize: ->
    @listenTo @model, 'loaded',   @applyLoadedState
    @listenTo @model, 'unloaded', @applyLoadedState
    @listenTo @model, 'invalid',  @markValidationErrors
    @listenTo @model.collection, 'collapse', @collapse

  onRender: ->
    @applyLoadedState()
    @expand() if @model.state.expanded

  # Updates the model attribute with the corresponding field value.
  #
  # @param [jQuery.Event] event the click event
  #
  updateModel: (event) =>
    el = $(event.currentTarget)
    attribute = el.attr 'name'

    return unless @model.has attribute

    @model.setStrict attribute, el.val()
    if @model.isValid() and @model.hasChanged(attribute)
      @enableSaveButton()
    else
      @disableSaveButton()

  # Shows or hides details of the timelet.
  #
  expand: ->
    return if @expanded
    @model.collection.trigger 'collapse'
    @expanded = true
    @ui.details.slideDown()

  # Hides details of the timelet.
  #
  collapse: ->
    return unless @expanded
    @expanded = false
    @ui.details.slideUp()

  # Deletes the timelet from the collection.
  #
  delete: -> @model.destroy()

  # Enables the save button.
  #
  enableSaveButton: ->
    @ui.save.fadeIn()
    @unmarkValidationErrors()

  # Disables the save button.
  #
  disableSaveButton: -> @ui.save.fadeOut()

  # Saves the timelet.
  #
  save: ->
    @model.save()
    @disableSaveButton()

  # Marks fields that did not pass model validation.
  #
  # @param [Backbone.Model] model The model
  # @param [Object] errors The error hash
  #
  markValidationErrors: (model, errors) =>
    for attribute, error of errors
      @$el.find("input[name=#{ attribute }]").addClass 'validation-error'

  # Removes validation error markings.
  #
  unmarkValidationErrors: ->
    @ui.fields.removeClass 'validation-error'

  # Sets the current timelet as the active one.
  #
  load: ->
    return if @model.isLoaded()
    @trigger 'timelet:load'
    Backbone.history.navigate "/timelet/#{ @model.id }"

  # Marks the timelet as loaded if applicable.
  #
  applyLoadedState: =>
    @$el.toggleClass 'loaded', @model.isLoaded()
