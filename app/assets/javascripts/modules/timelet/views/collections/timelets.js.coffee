# Collection view for timelet items.
#
class Essence.Views.Timelets extends Backbone.Marionette.CompositeView

  template: 'timelet/timelets'

  itemView: Essence.Views.Timelet
  itemViewContainer: 'section.timelets ul'

  emptyView: Essence.Views.NoTimelets
