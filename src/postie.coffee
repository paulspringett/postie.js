# Postie
# creates a new Postie object. Responds to two primary method calls:
# send - posts JSON data to another frame(s)
# listen - binds a user given callback function to message receive events, passing a PostieEvent object
class Postie
  listenCallback: null
  domain: '*'

  constructor: (options = {}) ->
    domain = options.domain if options.domain
  
  send: (frames, data, callback) ->
    new PostieSender(frames, data, callback)

  # Public: assign listener callback function
  listen: (callback) ->
    @listenCallback = callback
    @bindEventListener()

  onMessage: (rawEvent) =>
    event = @parseEvent(rawEvent)
    @listenCallback(event)

  parseEvent: (rawEvent) ->
    new PostieEvent(rawEvent)
  
  bindEventListener: ->
    if typeof(window.addEventListener) != 'undefined'
      window.addEventListener 'message', @onMessage, false
    else if typeof(window.attachEvent) != 'undefined'
      window.attachEvent 'onmessage', @onMessage

# Expose Postie to the DOM
window or= {}
window.Postie = Postie
