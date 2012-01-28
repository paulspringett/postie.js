class PostieEvent

  constructor: (event = {}) ->
    @origin = event.origin
    @data = JSON.parse(event.data)
    { data: @data, origin: origin }
