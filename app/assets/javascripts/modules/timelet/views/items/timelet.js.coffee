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
  # Triggers the 'load' event on the target model.
  #
  # @param [jQuery.Event] event the click event
  #
  load: (event) =>
    @options.activeModel.set @model.attributes, silent: true
    @options.activeModel.trigger 'load'
    Backbone.history.navigate "/timelet/#{ @model.id }"
