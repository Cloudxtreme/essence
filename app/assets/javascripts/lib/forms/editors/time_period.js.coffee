# Time period form type for Backbone.Forms
#
class Backbone.Form.editors.TimePeriod extends Backbone.Form.editors.Text
  tagName: 'div'

  events:
    'change input[type=checkbox]': 'updateCurrent'

  # Initialize the time span editor by creating the HTML structure and assign
  # UI references fort later usage.
  #
  # @param [Object] options the editor options
  #
  initialize: (@options) ->
    super @options

    @$el.append($("""
                  <div class='timeperiod'>
                    <select name='month'>
                      <option value='0'>#{ I18n.t('frontend.shared.months.jan') }</option>
                      <option value='1'>#{ I18n.t('frontend.shared.months.feb') }</option>
                      <option value='2'>#{ I18n.t('frontend.shared.months.mar') }</option>
                      <option value='3'>#{ I18n.t('frontend.shared.months.apr') }</option>
                      <option value='4'>#{ I18n.t('frontend.shared.months.mai') }</option>
                      <option value='5'>#{ I18n.t('frontend.shared.months.jun') }</option>
                      <option value='6'>#{ I18n.t('frontend.shared.months.jul') }</option>
                      <option value='7'>#{ I18n.t('frontend.shared.months.aug') }</option>
                      <option value='8'>#{ I18n.t('frontend.shared.months.sep') }</option>
                      <option value='9'>#{ I18n.t('frontend.shared.months.oct') }</option>
                      <option value='10'>#{ I18n.t('frontend.shared.months.nov') }</option>
                      <option value='11'>#{ I18n.t('frontend.shared.months.dec') }</option>
                    </select>
                    <input type='text' name='year' placeholder='#{ I18n.t('frontend.shared.year') }' />
                    <div class='today'>
                      #{ I18n.t('frontend.shared.today') }
                    </div>
                    <div class='current'>
                      <label><input name='current' type='checkbox' /> #{ I18n.t('frontend.shared.currently_working') }</label>
                    </div>
                  </div>
                  """))

    @month   = @$el.find 'select[name="month"]'
    @year    = @$el.find 'input[name="year"]'
    @current = @$el.find 'input[name="current"]'

    @$el.find('.today').hide()

    if @options.key is 'started'
      @$el.find('.current').hide()

  # Render the current view to render.
  #
  # @return [Backbone.Form.editors.Image] the editor
  #
  render: ->
    @setValue(@value)

    @

  # Set the time period data.
  #
  # @param [String] value the date
  #
  setValue: (@value = '') ->
    if @options.key is 'ended' and _.isEmpty(@value)
      @current.prop 'checked', true
      @updateCurrent()

    else
      @current.prop 'checked', false
      @updateCurrent()

      date = moment(@value)

      if date
        @month.val(date.month())
        @year.val(date.year())

  # Get the time period data.
  #
  # @return [String] the date
  #
  getValue: ->
    if @options.key is 'ended' and @current.is(':checked')
      @validators = []
      null
    else
      @validators = ['required']
      date = moment([parseInt(@year.val(), 10), @month.val()])

      if date.isValid()
        date.toJSON()
      else
        null

  # Update the UI depending on the checkbox
  #
  # @private
  #
  updateCurrent: ->
    if @current.is(':checked')
      @$el.find('.today').show()
      @month.hide()
      @year.hide()
    else
      @$el.find('.today').hide()
      @month.show()
      @year.show()
