module ApplicationHelper
  # Bootstrap the Rails flash messages to the
  # Backbone app. This is only used to pass Devise
  # authentication messages to the backbone app.
  #
  # @return [String] the flash messages
  #
  def bootstrap_notifications
    flash.inject([]) do |flashes, (type, message)|
      flashes.push({ type: type, message: message })
    end.to_json
  end

  # Bootstrap the authentication token that
  # is set by the {OmniauthController#login} to the
  # Backbone application and delete it afterwards from the
  # session, so we can work stateless after the initial OAuth request.
  #
  # @return [String] the JavaScript code fragment
  #
  def bootstrap_authentication_token
    token = session[:authentication_token]

    if token
      "'#{ token }'"
    else
      'null'
    end
  end

  # Bootstrap the tracking headers to the Backbone application
  # and delete it afterwards from the session.
  #
  # Tracking headers will be send back to the backend with
  # each API request, so you can track subsequent calls.
  #
  # @example Set a tracking header
  #   session[:tracking_headers] = { ambassador: 'x123' }
  #
  # @return [String] the JavaScript code fragment
  #
  def bootstrap_tracking_headers
    headers = session[:tracking_headers]

    if headers
      session[:tracking_headers] = nil
      "#{ ::ActiveSupport::JSON.encode(headers) }"
    else
      'null'
    end
  end

end
