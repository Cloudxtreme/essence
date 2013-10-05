# A single timelet view.
#
class Essence.Views.Timelet extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/timelet'
  tagName: 'li'

  ui:
    details:    '.details'
    name:       '.name'
    save:       '.save'
    attributes: '[data-attribute]'

  events:
    'click .delete'  : 'delete'
    'click .load'    : 'load'
    'click .name'    : 'expand'
    'click .close'   : 'collapse'
    'click .save'    : 'save'
    'blur .editable' : 'updateModel'

  initialize: ->
    @listenTo @model, 'loaded',   @applyLoadedState
    @listenTo @model, 'unloaded', @applyLoadedState
    @listenTo @model, 'invalid',  @markValidationErrors
    @listenTo @model.collection, 'collapse', @collapse

  onRender: ->
    @applyLoadedState()

  # Updates the model attribute with the corresponding field value.
  #
  # @param [jQuery.Event] event the click event
  #
  updateModel: (event) =>
    el = $(event.currentTarget)
    attribute = el.data 'attribute'

    return unless @model.has attribute

    @model.setStrict attribute, el.text()
    if @model.hasChanged(attribute) and @model.isValid()
      @enableSaveButton()
    else
      @disableSaveButton()

  # Shows or hides details of the timelet.
  #
  expand: ->
    return if @model.state.expanded
    @model.collection.trigger 'collapse'
    @model.state.expanded = true
    @ui.details.slideDown()

    @toggleNameEditability()

  # Hides details of the timelet.
  #
  collapse: ->
    return unless @model.state.expanded
    @model.state.expanded = false
    @ui.details.slideUp()

    @toggleNameEditability()

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
      @$el.find("[data-attribute=#{ attribute }]").addClass 'validation-error'

  # Removes validation error markings.
  #
  unmarkValidationErrors: ->
    @ui.attributes.removeClass 'validation-error'

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

  # Allow the name field to be edited if the details are expanded.
  #
  toggleNameEditability: =>
    if @model.state.expanded
      @ui.name.attr 'contentEditable', 'true'
      @ui.name.addClass 'editing'
    else
      @ui.name.removeAttr 'contentEditable'
      @ui.name.removeClass 'editing'
