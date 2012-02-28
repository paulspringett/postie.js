# PostieEvent
# Takes a raw postMessage event object, parses the data back into JSON
class PostieEvent
  success: false

  constructor: (event) ->
  	unless event
  	  throw "Cannot construct a PostieEvent with a postMessage event object"
    
    @origin = event.origin
    
    message = JSON.parse(event.data)
    @uuid = message.uuid
    @data = message.payload
    
    @sourceWindow = event.source
    
    @respond()

    @

  respond: ->
    new PostieSender(@sourceWindow, @response(), @sourceWindow)

  response: ->
    { success: true }
