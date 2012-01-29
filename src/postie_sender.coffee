class PostieSender

  constructor: (frames, data, callback) ->
    @parseFrames(frames)
    @prepareData
    @dispatch
    callback()

  parseFrames: (frames) ->
    _.each frames, (frame) ->
      if typeof(frame) is ''