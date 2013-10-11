class Essence.AudioPlayer

  @Audio = window.Audio || -> { play: -> }

  # Plays an audio file.
  #
  # @param [String] file Absolute URL pointing to the audio file
  #
  @play: (file) ->
    new @Audio(file).play()
