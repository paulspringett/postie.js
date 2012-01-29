# PostieEvent
# Takes a raw postMessage event object, parses the data back into JSON
class PostieEvent

  constructor: (event = {}) ->
    @origin = event.origin
    @data = JSON.parse(event.data)
    @sourceWindow = event.source
    { data: @data, origin: origin, source: @sourceWindow }
