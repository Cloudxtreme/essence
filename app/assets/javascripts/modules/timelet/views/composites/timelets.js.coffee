# Collection view of timelets.
#
# The @collection will render as an index of timelets which can be
# loaded into the clock.
#
class Essence.Views.Timelets extends Backbone.Marionette.CompositeView

  template: 'modules/timelet/templates/timelets'
  childViewContainer: 'ul'

  childView: Essence.Views.Timelet
  emptyView: Essence.Views.NoTimelet

  ui:
    timelets: 'ul'
    add:      '.add'

  events:
    'click .add': 'createTimelet'

  initialize: ->
    @on 'childview:timelet:load', (viewItem) =>
      @options.parent.trigger 'timelet:load', viewItem.model.id

  # Creates a new model of a timelet.
  #
  # @param [jQuery.Event] event the click event
  #
  createTimelet: (event) =>
    model = new Essence.Models.Timelet name: 'New Timelet'
    model.state.expanded = true
    @collection.add model
    Backbone.history.navigate '/timelet'
