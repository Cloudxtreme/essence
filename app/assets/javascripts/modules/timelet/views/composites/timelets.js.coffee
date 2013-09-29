# Collection view of timelets.
#
# The @collection will render as an index of timelets which can be
# loaded into the clock.
#
class Essence.Views.Timelets extends Backbone.Marionette.CompositeView

  template: 'modules/timelet/templates/timelets'
  itemViewContainer: 'ul'

  itemView: Essence.Views.Timelet
  emptyView: Essence.Views.NoTimelet

  events:
    'click .add': 'createTimelet'

  initialize: ->
    @listenTo @collection, 'sync', @render
    @on 'itemview:timelet:load', (viewItem) =>
      @options.parent.trigger 'timelet:load', id: viewItem.model.id

  # Creates a new model of a timelet.
  #
  # @param [jQuery.Event] event the click event
  #
  createTimelet: (event) =>
    @options.parent.trigger 'timelet:create'
    Backbone.history.navigate '/timelet'
