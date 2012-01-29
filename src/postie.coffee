# Postie
# creates a new Postie object. Responds to two primary method calls:
# send - posts JSON data to another frame(s)
# listen - binds a user given callback function to message receive events, passing a PostieEvent object
class Postie
  listenCallback: null
  domain: '*'

  constructor: (options = {}) ->
    @
  
  send: (frames, data, callback) ->
    console.log frames
    new PostieSender(frames, data, callback)

  # Public: assign listener callback function
  listen: (callback) ->
    @listenCallback = callback
    @bindEventListener

  onMessage: (event) ->
    event = @parseEvent(event)
    console.log event
    @listenCallback(event)

  parseEvent: (rawEvent) ->
    new PostieEvent(rawEvent)
  
  bindEventListener: ->
    if typeof(window.addEventListener) is not 'undefined'
      window.addEventListener 'message', @onMessage, false
    else if typeof(window.attachEvent) is not 'undefined'
      window.attachEvent 'onmessage', @onMessage

# Expose Postie to the DOM
window.Postie = Postie