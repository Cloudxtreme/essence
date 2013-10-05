module Support

  module Integration

    # Fill in a value into an element with the attribute contentEditable.
    #
    # @param [String] editable selector for the target element
    # @param [String] value the value to fill in
    # @param [Hash] options options to pass to the node finder
    #
    def fill_in_editable(editable, value, options = {})
      node = page.first :css, editable, options
      raise "Node not found" unless node

      # Activate the element
      node.click

      # Delete current value
      current_value = node.text
      current_value.length.times do
        node.native.send_keys :delete
      end

      node.native.send_keys value.to_s
    end

    # Create a timelet using the UI.
    #
    # @param [String] name the name of the timelet
    # @param [Integer] duration the duration of the timlet
    #
    def create_timelet(name, duration)
      within 'section.timelets' do 
        find('.add').click
        page.should have_content 'Duration:'
        fill_in_editable '.name.editable', name, text: 'New Timelet'
        fill_in_editable '.duration span.editable', duration.to_s, text: 0
        find('.details label').click
        find('.save').click
      end
    end

    # Initializes a fake clock in the browser.
    #
    def fake_time
      page.execute_script 'window.clock = sinon.useFakeTimers();'
    end

    # Skip time ahead in the browser.
    #
    # Requires to run @fake_time before.
    #
    # @param [Integer] duration Time in seconds
    #
    def advance(duration)
      page.execute_script "window.clock.tick(#{ duration * 1000 });"
    end
  end

end
