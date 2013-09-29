module Support

  module Integration

    # Fill in a value into an element with the attribute contentEditable.
    #
    # @param [String] editable selector for the target element
    # @param [String] value the value to fill in
    #
    def fill_in_editable(editable, value)
      node = page.first :css, editable
      raise "Must pass a hash containing 'from'" unless node

      # Activate the element
      node.click

      # Delete current value
      current_value = node.text
      current_value.length.times do
        node.native.send_keys :delete
      end

      node.native.send_keys value.to_s
    end

    # Create a timelet by using the clock view.
    #
    # @param [String] name the name of the timelet
    # @param [Integer] duration the duration of the timlet
    #
    def create_clock_timelet(name, duration)
      within 'section.clock' do 
        fill_in_editable 'span.name', name
        fill_in_editable 'span.time', duration.to_s
        find('.title').click
        find('.save').click
      end
    end

  end

end
