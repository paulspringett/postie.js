###
Postie.js
Copyright 2013 Paul Springett

Version: 0.1.1
Author: Paul Springett
URL: http://github.com/paulspringett/postie.js

Released under the MIT license
http://mit-license.org/
###

Postie = {}

# Postie.Client
# The Client references and connects to the Server in another Frame.
# The Available methods are fetched from the Server and instantiated
# as methods on the Client
# Example:
# ```
# client = new Postie.Client('#serveriframe')
# client.ready ->
#   client.getUser 123, (attrs) ->
#     @user = new User(attrs)
# ```
class Postie.Client
  _callbacks: []

  # Create a new client, and start listening to responses
  #
  # serverFrame - reference to the Window or iFrame the server is listening in
  #
  # Returns a Postie.Client
  constructor: (serverUrl) ->
    @_listen()
    @serverUrl = serverUrl

  # Wait until the server Frame is ready and then
  # request the available method endpoints from the
  # server's Receiver object
  #
  # `callback` - function to run when ready
  #
  # Returns nothing
  ready: (callback) ->
    @_createFrame @serverUrl, =>
      uuid = @_generateUuid()
      @_dispatch(uuid, 'getEndpoints', true)

      @_registerCallback uuid, (methods) =>
        @_createEndpoints(methods)
        callback()

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

    [uuid, fn]

  # Takes an argument and attempts to return a Window that can have
  # postMessage called on it successfully
  #
  # frame - String, Object or Function
  #
  # Raises Error if a Window cannot be parsed
  # Returns a Window
  _createFrame: (serverUrl, callback) ->
    frame = document.createElement('iframe')
    frame.setAttribute 'src', serverUrl
    frame.setAttribute 'id', 'postie-server-iframe'
    frame.setAttribute 'style', 'display:none;'

    frame.addEventListener 'load', callback, false
    document.body.appendChild frame

    @_frame = frame.contentWindow

  # Create methods on this client from the list of endpoints from the server
  #
  # Returns this
  _createEndpoints: (endpoints) ->
    @_endpoints = endpoints

    for endpoint in endpoints
      do (endpoint) =>
        @[endpoint] = (args...) ->
          [data, callback] = @_parseArgs(args)
          uuid = @_generateUuid()
          @_registerCallback(uuid, callback) if callback?
          @_dispatch(uuid, endpoint, data)
    @

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
  _dispatch: (uuid, method, data) ->
    payload = @_payload(uuid, method, data)
    @_frame.postMessage payload, '*'
    uuid

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
    message = { postie: true, uuid: uuid, method: method, payload: data }
    JSON.stringify(message)

  # Creates a randon UUID for each message
  #
  # Returns a String
  _generateUuid: ->
    s4 = ->
      (((1+Math.random())*0x10000)|0).toString(16).substring(1)

    "#{s4()}#{s4()}-#{s4()}-#{s4()}-#{s4()}-#{s4()}#{s4()}#{s4()}"

  # Bind to the window.message event to listen for incoming postMessage
  # events
  #
  # Binds event to @_receive
  # Returns nothing
  _listen: ->
    if window.addEventListener?
      window.addEventListener 'message', @_receive, false
    else if window.attachEvent?
      window.attachEvent 'onmessage', @_receive
    else
      throw new Error 'cannot bind to postMessage "message" event on window'

  # Receives the postMessage event, looks up a stored callback
  # function and calls it with the returned data
  #
  # rawEvent - postMessage Event
  #
  # Returns the remaining callbacks
  _receive: (rawEvent) =>
    event = new Postie.Event(rawEvent)
    return unless event.isValid

    callback = _.find @_callbacks, (cb) ->
      cb.uuid is event.uuid
    return unless callback?

    callback.fn(event.data)

    @_callbacks = _.filter @_callbacks, (cb) ->
      cb.uuid != callback.uuid

root = exports ? this
root.Postie = Postie
