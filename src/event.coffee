# PostieEvent
# Takes a raw postMessage event object, parses the data back into JSON
class Postie.Event
  success: false

  constructor: (event) ->
  	unless event
  	  throw "Cannot construct a PostieEvent with a postMessage event object"

    message = JSON.parse(event.data)

    @uuid = message.uuid
    @method = message.method
    @data = message.payload

    @source = event.source
