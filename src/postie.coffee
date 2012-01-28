class Postie
  listenCallback: null

  constructor: (options = {}) ->
    
  
  send: (frames, data, callback) ->
    console.log frames

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
    
