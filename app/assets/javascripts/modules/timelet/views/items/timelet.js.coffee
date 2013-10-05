# A single timelet view.
#
class Essence.Views.Timelet extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/timelet'
  tagName: 'li'

  ui:
    details:    '.details'
    label:      '.label'
    save:       '.save'
    attributes: '[data-attribute]'

  events:
    'click .delete'  : 'delete'
    'click .load'    : 'load'
    'click .name'    : 'expand'
    'click .close'   : 'collapse'
    'click .save'    : 'save'
    'blur .editable' : 'updateValue'

  initialize: ->
    @listenTo @model, 'change:loaded', @render
    @listenTo @model.collection, 'collapse', @collapse
    @listenTo @model, 'invalid', @markValidationErrors

  # Updates the model attribute with the corresponding field value.
  #
  # @param [jQuery.Event] event the click event
  #
  updateValue: (event) =>
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
    return if @model.expanded
    else
      @model.collection.trigger 'collapse'
      @model.expanded = true
      @ui.details.slideDown()
      @ui.label.attr 'contentEditable', 'true'
      @ui.label.addClass 'editing'

  # Hides details of the timelet.
  #
  collapse: ->
    return unless @model.expanded
    delete @model.expanded
    @ui.label.removeAttr 'contentEditable'
    @ui.label.removeClass 'editing'
    @ui.details.slideUp()

  # Deletes the timelet from the collection.
  #
  delete: -> @model.destroy()

  # Enables the save button.
  #
  enableSaveButton: ->
    @ui.save.fadeIn()
    @unmarkValidationErrors()

  disableSaveButton: -> @ui.save.fadeOut()

  # Saves the timelet.
  #
  save: ->
    @model.save
    @disableSaveButton()

  unmarkValidationErrors: ->
    @ui.attributes.removeClass 'validation-error'

  markValidationErrors: (model, errors) =>
    for attribute, error of errors
      @$el.find("[data-attribute=#{ attribute }]").addClass 'validation-error'

  # Sets the current timelet as the active one.
  #
  load: ->
    return if @model.isLoaded()
    @trigger 'timelet:load'
    Backbone.history.navigate "/timelet/#{ @model.id }"
