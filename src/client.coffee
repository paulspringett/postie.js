window.Postie = {}

class Postie.Client
  _callbacks: []

  constructor: (options = {}) ->
    @_listen()
    @_frame = @_parseFrame(options.server)
    @_endpoints = options.methods

  ready: (callback) ->
    console.log "Ready!", callback
    $(@_frame.document).ready =>
      uuid = @_dispatch('_getEndpoints', true)

      @_registerCallback uuid, (methods) =>
        console.log "callback", methods
        @_createEndpoints(methods)
        callback()

  # Create methods on this client from the list of endpoints from the server
  #
  # Returns a Boolean
  _createEndpoints: (endpoints) ->
    console.log "creating endpoints", endpoints
    for endpoint in endpoints
      @[endpoint] = (args...) ->
        [data, callback] = @_parseArgs(args)
        uuid = @_dispatch(endpoint, data)
        @_registerCallback(uuid, callback) if callback?

    true

  # Add the callback for the given UUID for the callbacks Array
  #
  # uuid - String of the UUID
  # fn - Function, the callback to run
  #
  # Returns an Array of the UUID and function added
  _registerCallback: (uuid, fn) ->
    @_callbacks.push
      uuid: uuid
      fn: fn

    console.log "registered callback", @_callbacks

    [uuid, fn]

  # Takes an argument and attempts to return a Window that can have
  # postMessage called on it successfully
  #
  # frame - String, Object or Function
  #
  # Raises Error if a Window cannot be parsed
  # Returns a Window
  _parseFrame: (frame) ->
    if typeof(frame) is 'string'
      frame = document.getElementById(frame)

    if typeof(frame.contentWindow) is 'object'
      frame = frame.contentWindow

    try
      if typeof(frame.postMessage) is 'function'
        return frame
    catch err
      throw new Error "Could not establish postMessage API for frame: #{frame}, must be an iframe"

  # Creates a payload String. postMessage only supports sending of string data.
  # Takes a UUID, endpoint method and data (any type) and creates a JSON object
  # which is then stringified
  #
  # uuid - String of the UUID
  # method - String of the endpoint method to run
  # data - Any (String, Int, JSON) of the data to send
  #
  # Returns a String
  _payload: (uuid, method, data) ->
    try
      message = { uuid: uuid, method: method, payload: data }
      JSON.stringify(message)
    catch err
      console.log "Could not stringify data: #{@data} with #{err}"

  # Take an artibuarty number of arguments and determine which is the data and
  # which is a callback function
  #
  # Returns an Array
  _parseArgs: (args) ->
    # If more than 2 args throw an error
    if args.length > 2
      throw new Error 'ArgumentError: more than 2 args passed to an endpoint. Pass a data argument and a callback argument only'

    # If 2 args, they should be in order already
    if args.length is 2
      return args

    # If only 1 arg, determine if it's a callback function or data
    if args.length is 1
      arg = args[0]

      if typeof(arg) is 'function'
        return [null, arg]

      else
        return [arg, null]

    [null, null]

  # Dispatch the encapsulated message to the Frame
  # using postMessage
  #
  # Returns a String of the Message's UUID
  _dispatch: (method, data) ->
    uuid = @_generateUuid()

    payload = @_payload(uuid, method, data)
    console.log "_dispatch payload", payload
    @_frame.postMessage payload, '*'
    uuid

  # Creates a randon UUID for each message
  #
  # Returns a String
  _generateUuid: ->
    s4 = ->
      (((1+Math.random())*0x10000)|0).toString(16).substring(1)

    "#{s4()}#{s4()}-#{s4()}-#{s4()}-#{s4()}-#{s4()}#{s4()}#{s4()}"

  _listen: ->
    if window.addEventListener?
      window.addEventListener 'message', @_receive, false
    else if window.attachEvent?
      window.attachEvent 'onmessage', @_receive
    else
      throw new Error 'cannot bind to postMessage "message" event on window'

  _receive: (rawEvent) =>
    event = new Postie.Event(rawEvent)

    callback = _.find @_callbacks, (cb) ->
      cb.uuid is event.uuid

    return unless callback?

    callback.fn(event.data)

    @_callbacks = _.without @_callbacks, callback


