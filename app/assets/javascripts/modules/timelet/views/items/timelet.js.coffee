# A single timelet view.
#
class Essence.Views.Timelet extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/timelet'
  tagName: 'li'

  ui:
    details: '.details'

  events:
    'click .delete': 'delete'
    'click .load':   'load'
    'click .label':  'open'

  initialize: ->
    @listenTo @model, 'change:loaded', @render
    @listenTo @model.collection, 'close', @close

  # Shows or hides details of the timelet.
  #
  open: ->
    if @model.expanded
      @close()
    else
      @model.collection.trigger 'close'
      @model.expanded = true
      @ui.details.slideDown()

  # Hides details of the timelet.
  #
  close: ->
    delete @model.expanded
    @ui.details.slideUp()

  # Deletes the timelet from the collection.
  #
  delete: ->
    @model.destroy()

  # Sets the current timelet as the active one.
  #
  load: ->
    return if @model.isLoaded()
    @trigger 'timelet:load'
    Backbone.history.navigate "/timelet/#{ @model.id }"
