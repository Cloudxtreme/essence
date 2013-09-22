# The backbone controller is responsible for rendering
# the initial page for starting the Backbone application.
#
class BootstrapController < ApplicationController

  # Render the Backbone application
  #
  def app
    respond_to do |format|
      format.html
    end
  end

end
