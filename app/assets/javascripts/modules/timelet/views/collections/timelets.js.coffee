# Collection view for timelet items.
#
class Essence.Views.Timelets extends Backbone.Marionette.CompositeView

  template: 'modules/timelet/templates/timelets'

  itemView: Essence.Views.Timelet
  itemViewContainer: 'section.timelets ul'

  emptyView: Essence.Views.NoTimelet

  initialize: ->
    @listenTo @collection, 'change', @render
