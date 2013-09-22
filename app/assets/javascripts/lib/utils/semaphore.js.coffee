# Utility class for providing semaphore mechanics on buttons.
#
class Essence.Semaphore

  # Establishes or checks a lock on provided element.
  #
  # @param [Element] element the element on which to place the lock
  # @return true if a lock has been placed, false otherwise
  #
  @requestSemaphore: (element) =>
    return false if @semaphore
    element.addClass 'disabled'
    @semaphore = element

  # Release the lock.
  #
  @releaseSemaphore: =>
    @semaphore?.removeClass 'disabled'
    delete @semaphore

  @isLocked: =>
    @semaphore?
