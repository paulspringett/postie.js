# PostieEvent
# Takes a raw postMessage event object, parses the data back into JSON
# and provide useful accessor methods
# Example:
# ```
# event = new Postie.Event(rawPostMessageEvent)
# event.data
# => { foo: "bar" }
# ```
class Postie.Event
  success: false
  isValid: false

  constructor: (event) ->
    try
      message = JSON.parse(event.data)

      @isValid = true if message.postie

      @uuid = message.uuid
      @method = message.method
      @data = message.payload

      # This is the origin of the postMessage
      # Send responses to @source
      @source = event.source

    catch err
      console.log "Failed to parse JSON #{event.data}, with error: #{err}"
      @isValid = false
