# A single timelet view.
#
class Essence.Views.Timelet extends Backbone.Marionette.ItemView
  template: 'modules/timelet/templates/timelet'
  tagName: 'li'

  events:
    'click .delete': 'delete'

  # Deletes the timelet from the collection.
  #
  # @param [jQuery.Event] event the click event
  #
  delete: (event) =>
    @model.destroy()
