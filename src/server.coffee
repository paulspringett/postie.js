# Postie.Server
# The server listens for requests
# When receiving a request from a Client it
# calls the requested endpoint method on it's Receiver
# and returns the response via another postMessage
# Example:
# ```
# myReceiver =
#  getUser: (id) ->
#    Users.find(id)
#
# server = new Postie.Server(receiver: myReceiver)
# server.listen()
# ```
#
# The Receiver
# This is a JSON object that contains a list of endpoint method
# names and corresponding functions. When the Client requests an
# endpoint the Server look for a key in the Receiver with the same
# name
class Postie.Server
  endpoints: []

  # Create a new Server
  #
  # options.receiver - a JSON object with endpoints and functions
  #
  # Returns a Postie.Server
  constructor: (options = {}) ->
    @receiver = options.receiver
    @_listEndpoints()

  # Receive a postMessage event
  # Either return the available endpoints or pass
  # the method call to the Receiver. Then dispatch
  # the response
  #
  # rawEvent - postMessage Event object
  #
  # Returns nothing
  receive: (rawEvent) =>
    event = new Postie.Event(rawEvent)

    if event.method is '_getEndpoints'
      return @dispatch(event, @endpoints)

    responseData = @receiver[event.method](event.data)
    @dispatch(event, responseData)

  # Dispatch the encapsulated message to the source
  # using postMessage
  #
  # Returns a String of the Message's UUID
  dispatch: (event, responseData) ->
    frame = event.source

    payload = @payload(event.uuid, responseData)
    frame.postMessage payload, '*'
    event.uuid

  # Creates a payload String. postMessage only supports sending of string data.
  # Takes a UUID and data (any type) and creates a JSON object which is then stringified
  #
  # uuid - String of the UUID
  # data - Any (String, Int, JSON) of the data to send
  #
  # Returns a String
  payload: (uuid, data) ->
    message = { uuid: uuid, payload: data }
    JSON.stringify(message)

  # Bind to the window.message event to listen for incoming postMessage
  # events
  #
  # Binds event to @receive
  # Returns nothing
  listen: ->
    if window.addEventListener?
      window.addEventListener 'message', @receive, false
    else if window.attachEvent?
      window.attachEvent 'onmessage', @receive
    else
      throw new Error 'cannot bind to postMessage "message" event on window'

  # Get the list of methods from the receiver and add them
  # to an Array of @endpoints
  #
  # receiver - the Receiver
  #
  # Returns an Array
  _listEndpoints: (receiver) ->
    for method, fn of receiver
      @endpoints.push method

    @endpoints
