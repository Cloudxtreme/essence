# A single timelet view.
#
class Essence.Views.Timelet extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/timelet'
  tagName: 'li'

  events:
    'click .delete': 'delete'
    'click .load':   'load'

  # Deletes the timelet from the collection.
  #
  # @param [jQuery.Event] event the click event
  #
  delete: (event) =>
    @model.destroy()

  # Sets the current timelet as the active one.
  #
  # @param [jQuery.Event] event the click event
  #
  load: (event) =>
    @trigger 'timelet:load'
    Backbone.history.navigate "/timelet/#{ @model.id }"
