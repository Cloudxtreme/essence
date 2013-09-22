# Base class for form based item views. Contains mostly shared
# helpers for handling the form.
#
class Essence.FormView extends Backbone.Marionette.ItemView

  events:
    'click input[type=submit]': 'doSave'

  ui:
    submit: 'input[type=submit]'

  # Defines the default option set used for REDACTOR
  #
  # @param [Object] options the custom options
  # @return [Object] the default Redactor options
  #
  getRedactorOptions: (options = {}) ->
    _.extend options, {
      lang: I18n.locale
      minHeight: 300
      textareamode: true
      linebreaks: true
      buttons: ['formatting',
                '|', 'bold', 'italic',
                '|', 'unorderedlist', 'orderedlist', 'outdent', 'indent',
                '|', 'table', 'link',
                '|', 'alignleft', 'aligncenter', 'alignright', 'justify',
                '|', 'horizontalrule']
    }

  # Save the form. Can be used as default form handler
  # if only one form with a model is used.
  #
  # @param [jQuery.Event] event the click event
  #
  doSave: (event) =>
    event?.preventDefault()
    @saveForm() if @requestSemaphore()

  # Establish or check a lock on the form submit button.
  #
  # If no element is specified, @ui.submit will be used.
  #
  # @param [Element] element the element on which to place the lock
  # @return true if a lock has been placed, false otherwise
  #
  requestSemaphore: (element) =>
    element = @ui.submit unless element
    Essence.Semaphore.requestSemaphore element

  # Release the lock.
  #
  releaseSemaphore: =>
    Essence.Semaphore.releaseSemaphore()

  # Called after the form has been saved successfully.
  #
  # @param [Essence.Model] model the persisted model
  # @param [Object] response the decoded response
  # @param [Options] options the options
  #
  onSuccess: (model, response, options) =>
    @releaseSemaphore()

  # Called after saving the form has failed.
  #
  # @param [Essence.Model] model the persisted model
  # @param [jqXHR] xhr the jQuery XHR object
  # @param [Options] options the options
  #
  onError: (model, xhr, options) =>
    @releaseSemaphore()

  # Commits the changes from the form into the model
  # and persists it to the backend. On error it passes
  # server side errors back to the form.
  #
  # @param [Backbone.Form] form the form of the model
  # @param [Essence.Model] model the model to persist
  #
  saveForm: (form = @form, model = form.model) ->
    errors = form.commit()

    unless errors
      model.save {}, {
        success: (model, response, options) =>
          @onSuccess(model, response, options)

        error: (model, xhr, options) =>
          @setServerErrors(form, xhr)
          @onError(model, xhr, options)
      }
    else
      @releaseSemaphore()

  # Applies server side errors to the form.
  #
  # @param [Backbone.Form] form the form to set the errors on
  # @param [XHR] xhr the failed request
  #
  setServerErrors: (form, xhr) ->
    errors = try JSON.parse(xhr.responseText).errors

    for name, msgs of errors
      current = form

      for segment in name.split '.'
        fields = (current?.fields || current?.editor.form.fields)
        field = current = fields?[segment]

      field.setError msgs.join(', ') if field
